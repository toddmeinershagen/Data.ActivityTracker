using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Threading;
using System.Threading.Tasks;
using System.Timers;
using Dapper;
using NLog;
using Topshelf;
using Timer = System.Timers.Timer;

namespace CommonGround.Data.ActivityTracker
{
    public class TrackerService : ServiceControl
    {
        private static volatile object _lock = new object();
        private const string ActivitytrackerDbName = "ActivityTracker";
        private static readonly Logger Logger = LogManager.GetCurrentClassLogger();
        private readonly Timer _timer;

        public TrackerService(TimeSpan sampleInterval)
        {
            _timer = new Timer(sampleInterval.TotalMilliseconds) { AutoReset = true };
            _timer.Elapsed += _timer_Elapsed;
        }

        private void _timer_Elapsed(object sender, ElapsedEventArgs e)
        {
            var lockWasTaken = false;

            try
            {
                if (Monitor.TryEnter(_lock) == false) return;

                lockWasTaken = true;
                TakeSample();
            }
            catch (Exception ex)
            {
                Logger.Error(ex);
            }
            finally
            {
                if (lockWasTaken)
                {
                    Monitor.Exit(_lock);
                }
            }
        }

        private void TakeSample()
        {
            var gatherDataPath = Path.Combine(Environment.CurrentDirectory, "Scripts", "gather-data.sql");
            var gatherDataSql = File.ReadAllText(gatherDataPath);

            var actions = new List<Action>();

            foreach (var connection in GetSourceConnections())
            {
                actions.Add(() =>
                {
                    var tvp = new DataTable();

                    using (connection)
                    {
                        using (var adapter = new SqlDataAdapter(gatherDataSql, connection))
                        {
                            adapter.SelectCommand.CommandType = CommandType.Text;
                            adapter.Fill(tvp);
                        }
                    }

                    using (var activityConnection = GetTargetConnection())
                    {
                        var procedureName = "[dbo].[usp_InsertActivity]";
                        activityConnection.Execute(procedureName, new {tvp},
                            commandType: CommandType.StoredProcedure);
                    }
                });
            }

            Parallel.Invoke(actions.ToArray());
        }

        public IDbConnection GetTargetConnection()
        {
            return new SqlConnection(ConfigurationManager.ConnectionStrings[ActivitytrackerDbName].ConnectionString);
        }

        public IEnumerable<SqlConnection> GetSourceConnections()
        {
            foreach (ConnectionStringSettings connectionString in ConfigurationManager.ConnectionStrings)
            {
                if (connectionString.Name != ActivitytrackerDbName)
                {
                    yield return new SqlConnection(connectionString.ConnectionString);
                }
            }
        }

        public bool Start(HostControl hostControl)
        {
            _timer.Start();
            return true;
        }

        public bool Stop(HostControl hostControl)
        {
            _timer.Stop();
            return true;
        }
    }
}

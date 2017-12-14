using System;
using Topshelf;
using System.Configuration;

namespace CommonGround.Data.ActivityTracker
{
    class Program
    {
        static void Main(string[] args)
        {
            HostFactory.Run(x =>
            {
                x.Service(() => new TrackerService(SampleInterval));
                x.UseNLog();
            });
        }

        public static TimeSpan SampleInterval
        {
            get
            {
                var seconds = ConfigurationManager.AppSettings["SampleIntervalInSeconds"] ?? "300";
                return TimeSpan.FromSeconds(int.Parse(seconds));
            }
        }
    }
}

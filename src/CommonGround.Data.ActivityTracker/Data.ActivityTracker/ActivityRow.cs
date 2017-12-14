using System;

namespace CommonGround.Data.ActivityTracker
{
    public class ActivityRow
    {
        public string InstanceName { get; set; }
        public int SessionActivityID { get; set; }
        public short SPID { get; set; }
        public int NumWorkers { get; set; }
        public short BlockedBy { get; set; }
        public string Status { get; set; }
        public string LoginName { get; set; }
        public string HostName { get; set; }
        public string ProgramName { get; set; }
        public string DatabaseName { get; set; }
        public DateTime StartTime { get; set; }
        public int CPU_Time_MS { get; set; }
        public string CPU_Time { get; set; }
        public int ElapsedTime_MS { get; set; }
        public string ElapsedTime { get; set; }
        public int WaitTime_MS { get; set; }
        public string WaitTime { get; set; }
        public string WaitType { get; set; }
        public string WaitResource { get; set; }
        public DateTime grant_time { get; set; }
        public decimal requested_memory_MB { get; set; }
        public decimal granted_memory_MB { get; set; }
        public decimal required_memory_MB { get; set; }
        public decimal used_memory_MB { get; set; }
        public decimal max_used_memory_MB { get; set; }
        public decimal ideal_memory_MB { get; set; }
        public long Reads { get; set; }
        public long Writes { get; set; }
        public long LogicalReads { get; set; }
        public int OpenTranCount { get; set; }
        public string ObjectName { get; set; }
        public string SqlStatement { get; set; }
        public string SqlText { get; set; }
        public string Blocker_Status { get; set; }
        public string Blocker_HostName { get; set; }
        public string Blocker_LoginName { get; set; }
        public string Blocker_ObjectName { get; set; }
        public string Blocker_SqlStatement { get; set; }
        public DateTime Blocker_StartTime { get; set; }
        public string Blocker_ElapsedTime { get; set; }
    }
}
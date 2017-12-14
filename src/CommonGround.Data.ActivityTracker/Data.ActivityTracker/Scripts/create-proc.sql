 CREATE TYPE ActivityTableType AS TABLE   
( 
	InstanceName Varchar(255),	
	[SPID] [smallint],
	[NumWorkers] [int],
	[BlockedBy] [smallint],
	[Status] [varchar](30),
	[LoginName] [varchar](128),
	[HostName] [varchar](128),
	[DatabaseName] [varchar](128),
	[StartTime] [datetime],
	[CPU_Time_MS] [int],
	[CPU_Time] [varchar](30),
	[ElapsedTime_MS] [int],
	[ElapsedTime] [varchar](30),
	[WaitTime_MS] [int],
	[WaitTime] [varchar](30),
	[WaitType] [varchar](60),
	[WaitResource] [varchar](256),
	[grant_time] [datetime],
	[requested_memory_MB] [decimal](20, 2),
	[granted_memory_MB] [decimal](20, 2),
	[required_memory_MB] [decimal](20, 2),
	[used_memory_MB] [decimal](20, 2),
	[max_used_memory_MB] [decimal](20, 2),
	[ideal_memory_MB] [decimal](20, 2),
	[Reads] [bigint],
	[Writes] [bigint],
	[LogicalReads] [bigint],
	[OpenTranCount] [int],
	[ObjectName] [varchar](128),
	[SqlStatement] [varchar](max),
	[SqlText] [varchar](max),
	[Blocker_Status] [varchar](30),
	[Blocker_HostName] [varchar](128),
	[Blocker_LoginName] [varchar](128),
	[Blocker_ObjectName] [varchar](128),
	[Blocker_SqlStatement] [varchar](max),
	[Blocker_StartTime] [datetime],
	[Blocker_ElapsedTime] [varchar](30)
);  
GO  


CREATE PROCEDURE dbo.usp_InsertActivity  
    @TVP ActivityTableType READONLY  
    AS   
    SET NOCOUNT ON  
    INSERT INTO [dbo].[ActiveSessionLog] 
	(
		 InstanceName
		,  SPID
		, NumWorkers
		, BlockedBy
		, [Status]
		, LoginName
		, HostName
		, DatabaseName
		, StartTime
		, CPU_Time_MS
		, CPU_Time
		, ElapsedTime_MS
		, ElapsedTime
		, WaitTime_MS
		, WaitTime
		, WaitType
		, WaitResource
		, grant_time
		, requested_memory_MB
		, granted_memory_MB
		, required_memory_MB
		, used_memory_MB
		, max_used_memory_MB
		, ideal_memory_MB
		, Reads
		, Writes
		, LogicalReads
		, OpenTranCount
		, ObjectName
		, SqlStatement
		, SqlText
		, Blocker_Status
		, Blocker_HostName
		, Blocker_LoginName
		, Blocker_ObjectName
		, Blocker_SqlStatement
		, Blocker_StartTime
		, Blocker_ElapsedTime
		, Logdate
	)
	Select InstanceName
		, SPID
		, NumWorkers
		, BlockedBy
		, [Status]
		, LoginName
		, HostName
		, DatabaseName
		, StartTime
		, CPU_Time_MS
		, CPU_Time
		, ElapsedTime_MS
		, ElapsedTime
		, WaitTime_MS
		, WaitTime
		, WaitType
		, WaitResource
		, grant_time
		, requested_memory_MB
		, granted_memory_MB
		, required_memory_MB
		, used_memory_MB
		, max_used_memory_MB
		, ideal_memory_MB
		, Reads
		, Writes
		, LogicalReads
		, OpenTranCount
		, ObjectName
		, SqlStatement
		, SqlText
		, Blocker_Status
		, Blocker_HostName
		, Blocker_LoginName
		, Blocker_ObjectName
		, Blocker_SqlStatement
		, Blocker_StartTime
		, Blocker_ElapsedTime
		, GETDATE() 
        FROM  @TVP;  
        GO  
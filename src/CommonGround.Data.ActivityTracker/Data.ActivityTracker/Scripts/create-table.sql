CREATE TABLE [dbo].[ActiveSessionLog]
(
	InstanceName Varchar(255) NOT NULL,
	[SessionActivityID] [int] IDENTITY(1,1) NOT NULL,	
	[SPID] [smallint] NOT NULL,
	[NumWorkers] [int] NOT NULL,
	[BlockedBy] [smallint] NOT NULL,
	[Status] [varchar](30) NOT NULL,
	[LoginName] [varchar](128) NOT NULL,
	[HostName] [varchar](128) NOT NULL,
	[DatabaseName] [varchar](128) NOT NULL,
	[StartTime] [datetime] NOT NULL,
	[CPU_Time_MS] [int] NOT NULL,
	[CPU_Time] [varchar](30) NULL,
	[ElapsedTime_MS] [int] NOT NULL,
	[ElapsedTime] [varchar](30) NULL,
	[WaitTime_MS] [int] NOT NULL,
	[WaitTime] [varchar](30) NOT NULL,
	[WaitType] [varchar](60) NOT NULL,
	[WaitResource] [varchar](256) NOT NULL,
	[grant_time] [datetime] NULL,
	[requested_memory_MB] [decimal](20, 2) NULL,
	[granted_memory_MB] [decimal](20, 2) NULL,
	[required_memory_MB] [decimal](20, 2) NULL,
	[used_memory_MB] [decimal](20, 2) NULL,
	[max_used_memory_MB] [decimal](20, 2) NULL,
	[ideal_memory_MB] [decimal](20, 2) NULL,
	[Reads] [bigint] NOT NULL,
	[Writes] [bigint] NOT NULL,
	[LogicalReads] [bigint] NOT NULL,
	[OpenTranCount] [int] NOT NULL,
	[ObjectName] [varchar](128) NOT NULL,
	[SqlStatement] [varchar](max) NOT NULL,
	[SqlText] [varchar](max) NOT NULL,
	[Blocker_Status] [varchar](30) NULL,
	[Blocker_HostName] [varchar](128) NULL,
	[Blocker_LoginName] [varchar](128) NULL,
	[Blocker_ObjectName] [varchar](128) NULL,
	[Blocker_SqlStatement] [varchar](max) NULL,
	[Blocker_StartTime] [datetime] NULL,
	[Blocker_ElapsedTime] [varchar](30) NULL,
	[LogDate] [datetime] NOT NULL
) ON [PRIMARY] 
GO


ALTER TABLE [dbo].[ActiveSessionLog] ADD  CONSTRAINT [PK_ActiveSessionLog] PRIMARY KEY CLUSTERED 
(	
	[LogDate],
	[InstanceName],
	[DatabaseName],
	[SessionActivityId]
)
GO
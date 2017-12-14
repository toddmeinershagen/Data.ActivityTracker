DECLARE @MinElapsedTime_MS INT

IF OBJECT_ID('tempdb.dbo.#Temp') IS NOT NULL
DROP TABLE #Temp;

WITH ca
     AS (
     SELECT @@Servername as InstanceName, 
	   --[ProgramName] = COALESCE(j.name, s.program_name, ''),
            [LoginName] = s.login_name,
            [HostName] = ISNULL(s.host_name, ''),
            [DatabaseID] = r.database_id,
            [DatabaseName] = DB_NAME(r.database_id),
            [objectid] = st.objectid,
            [ObjectName] = ISNULL(OBJECT_NAME(st.objectid, st.dbid), ''),
            [Command] = r.command,
            [SqlText] = ISNULL(st.text, ''),
            [SqlStatement] = CASE
                                 WHEN st.text IS NULL
                                 THEN ''
                                 ELSE SUBSTRING(st.text,
                                                   CASE
                                                       WHEN r.statement_start_offset IS NULL
                                                            OR r.statement_start_offset > LEN(st.text)
                                                       THEN 0
                                                       ELSE r.statement_start_offset/2+1
                                                   END, ((CASE
                                                              WHEN r.statement_end_offset = 0
                                                                   OR r.statement_end_offset = -1
                                                                   OR r.statement_end_offset IS NULL
                                                              THEN LEN(ISNULL(text, ''))
                                                              ELSE r.statement_end_offset
                                                          END)-(CASE
                                                                    WHEN r.statement_start_offset = 0
                                                                         OR r.statement_start_offset IS NULL
                                                                    THEN 1
                                                                    ELSE CASE
                                                                             WHEN r.statement_start_offset IS NULL
                                                                                  OR r.statement_start_offset > LEN(st.text)
                                                                             THEN 0
                                                                             ELSE r.statement_start_offset/2+1
                                                                         END
                                                                END)+1))
                             END,
            [SPID] = r.session_id,
            [BlockedBy] = r.blocking_session_id,
            r.Status,
            [StartTime] = r.start_time,
            [CPU_Time_MS] = r.cpu_time,
            [ElapsedTime_MS] = r.total_elapsed_time,
            [WaitType] = ISNULL(r.wait_type, ''),
            [WaitTime_MS] = r.wait_time,
            [WaitResource] = r.wait_resource,
            [PercentComplete] = r.percent_complete,
            [EstimatedCompletionTime] = r.estimated_completion_time,
            r.Reads,
            r.Writes,
            [LogicalReads] = r.logical_reads,
            [OpenTranCount] = r.open_transaction_count,
            [Row_Count] = r.row_count,
            [NumWorkers] = nw.NumWorkers,
            grant_time,
            requested_memory_MB = requested_memory_kb / 1024.0,
            granted_memory_MB = granted_memory_kb / 1024.0,
            required_memory_MB = required_memory_kb / 1024.0,
            used_memory_MB = used_memory_kb / 1024.0,
            max_used_memory_MB= max_used_memory_kb / 1024.0,
            ideal_memory_MB = ideal_memory_kb / 1024.0 
     FROM sys.dm_exec_requests r
          INNER JOIN sys.dm_exec_sessions s ON r.session_id = s.session_id
          CROSS APPLY sys.dm_exec_sql_text(r.sql_handle) st
          INNER JOIN (	SELECT session_id,
						  MAX(isnull(exec_context_id, 0)) NumWorkers
					FROM sys.dm_os_tasks
					GROUP BY session_id ) nw ON r.session_id = nw.session_id
          --LEFT OUTER JOIN msdb.dbo.sysjobs j ON(dbo.ufn_HexToChar(j.job_id, 16) = SUBSTRING(s.program_name, 30, 34))
		--  AND (s.program_name LIKE 'SQLAgent - TSQL JobStep%')
          LEFT OUTER JOIN sys.dm_exec_query_memory_grants mg ON mg.session_id = r.session_id
     WHERE r.session_id <> @@SPID)
     SELECT s1.InstanceName,
		  s1.SPID,
            s1.NumWorkers,
            s1.BlockedBy,
            s1.Status,
            s1.LoginName,
            s1.HostName,
           -- s1.ProgramName,
            s1.DatabaseName,
            s1.StartTime,
            s1.CPU_Time_MS,
            [CPU_Time] = CONVERT(VARCHAR, DATEADD(ms, s1.CPU_Time_MS, 0), 114),
            s1.ElapsedTime_MS,
            [ElapsedTime] = CONVERT(VARCHAR, DATEADD(ms, s1.ElapsedTime_MS, 0), 114),
            s1.WaitTime_MS,
            [WaitTime] = CONVERT(VARCHAR, DATEADD(ms, s1.WaitTime_MS, 0), 114),
            s1.WaitType,
            s1.WaitResource,
            s1.Reads,
            s1.Writes,
            s1.LogicalReads,
            s1.OpenTranCount,
            s1.ObjectName,
            s1.Command,
            s1.SqlStatement,
            s1.SqlText,
            s1.grant_time,
            s1.requested_memory_MB,
            s1.granted_memory_MB,
            s1.required_memory_MB,
            s1.used_memory_MB,
            s1.max_used_memory_MB,
            s1.ideal_memory_MB,
            [Blocker_Status] = s2.Status,
            [Blocker_HostName] = s2.HostName,
            [Blocker_LoginName] = s2.LoginName,
            [Blocker_ObjectName] = s2.ObjectName,
            [Blocker_Command] = s2.Command,
            [Blocker_SqlStatement] = s2.SqlStatement,
            [Blocker_SqlText] = s2.SqlText,
            [Blocker_StartTime] = s2.StartTime,
            [Blocker_ElapsedTime_MS] = s2.ElapsedTime_MS,
            [Blocker_ElapsedTime] = CONVERT(VARCHAR, DATEADD(ms, s2.ElapsedTime_MS, 0), 114),
            [Blocker_requested_memory_MB] = s2.requested_memory_MB,
            [Blocker_granted_memory_MB] = s2.granted_memory_MB,
            [Blocker_required_memory_MB] = s2.required_memory_MB,
            [Blocker_used_memory_MB] = s2.used_memory_MB,
            [Blocker_max_used_memory_MB] = s2.max_used_memory_MB
     INTO #Temp
	FROM ca s1
     LEFT OUTER JOIN ca s2 ON s1.BlockedBy = s2.SPID

	Select InstanceName
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
	FROM #Temp
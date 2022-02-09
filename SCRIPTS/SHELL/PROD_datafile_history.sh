sqlplus -s / as sysdba << EOF
set pages 100
set lines 180
col TABLESPACE_NAME for a30
col DATAFILE_NAME for a120
col SIZE for a12
col CREATION_TIME for a20

spool ${BACKUP_ARCH_DIR1}/1.Datafile_history.log

select TABLESPACE_NAME, NAME as DATAFILE_NAME, to_char(BYTES/1024/1024) || ' MB' "SIZE", 
	to_char(CREATION_TIME, 'yyyy/mm/dd hh24:mi:ss') as CREATION_TIME from v\$datafile_header
	where to_char(CREATION_TIME, 'yyyymmdd') >= ${TSChange}
	order by CREATION_TIME;
spool off;
EOF

${ORACLE_HOME}/bin/sqlplus -s $1/$2@$3 << EOF
set lines 200
set pagesize 40
col DB_NAME for a12
col start_time for a20
col end_time for a15
col BACKUP_JOB for a11
col "SESSION" for 9999999
col STATUS for a25
col "DEVICE" for a6
col "OUTPUT_BYTE" for a12
col "INPUT_BYTE" for a12
col "OUT_BYTE/s" for a10
col "TIME_TAKEN" for a10
SELECT DB_NAME,
  SESSION_KEY "SESSION",
  TO_CHAR(start_time,'yyyy-mm-dd hh24:mi:ss') START_TIME ,
  TO_CHAR(end_time,'mm-dd hh24:mi:ss') END_TIME ,
  INPUT_TYPE BACKUP_JOB,
  STATUS,
  OUTPUT_DEVICE_TYPE DEVICE,
  INPUT_BYTES_DISPLAY "INPUT_BYTE",
  OUTPUT_BYTES_DISPLAY "OUTPUT_BYTE",
  OUTPUT_BYTES_PER_SEC_DISPLAY "OUT_BYTE/s",
  TIME_TAKEN_DISPLAY "TIME_TAKEN"
FROM RC_RMAN_BACKUP_JOB_DETAILS jb
WHERE db_key =( select db_key from ( select row_number() over (order by db_key) as sr_no,reg_db_unique_name,db_key from db) where sr_no = $4)
and INPUT_TYPE IN ('DB INCR','DB FULL','ARCHIVELOG')
and start_time >= sysdate - 7
ORDER BY start_time,command_id
/
EOF

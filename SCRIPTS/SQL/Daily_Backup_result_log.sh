STIME=`cat /${ZFS_TEMP_DIR}/${DB_NAME}_STIME.out`
sqlplus -s / as sysdba << EOF
set linesize 200
set pagesize 55
set feedback off
col "SESSION" for 9999999
col START_DATE_TIME for a20
col END_DATE_TIME for a15
col BACKUP_JOB for a11
col STATUS for a25
col DEVICE for a8
col IN_BYTES for a11
col OUT_BYTES for a11
col "INPUT/sec" for a11
col "OUTPUT/sec" for a11
col TIME_TAKEN for a10

SELECT
SESSION_KEY "SESSION",
TO_CHAR(START_TIME,'yyyy/mm/dd_hh24:mi:ss') start_date_time,
TO_CHAR(END_TIME,'mm/dd_hh24:mi:ss') end_date_time,
INPUT_TYPE BACKUP_JOB,
STATUS ,
OUTPUT_DEVICE_TYPE DEVICE,
INPUT_BYTES_DISPLAY IN_BYTES,
OUTPUT_BYTES_DISPLAY OUT_BYTES,
INPUT_BYTES_PER_SEC_DISPLAY "INPUT/sec",
OUTPUT_BYTES_PER_SEC_DISPLAY "OUTPUT/sec",
TIME_TAKEN_DISPLAY time_taken
FROM V\$RMAN_BACKUP_JOB_DETAILS
WHERE to_char(START_TIME,'yyyy/mm/dd_hh24:mi:ss') >= '$STIME'
ORDER BY START_TIME;
EOF

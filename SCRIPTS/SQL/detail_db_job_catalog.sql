set lines 200
col DB_NAME for a10
col start_time for a20
col end_time for a15
col input_type for a10
col "TIME_TAKEN" for a10
col "Output MB" for 999,999,999
col "Input MB" for 999,999,999
col "DEVICE" for a6
SELECT DB_NAME,
  TO_CHAR(start_time,'yyyy-mm-dd hh24:mi:ss') START_TIME ,
  TO_CHAR(end_time,'mm-dd hh24:mi:ss') END_TIME ,
  INPUT_TYPE ,
  STATUS,
  OUTPUT_DEVICE_TYPE "DEVICE",
  TRUNC(INPUT_BYTES /1024/1024) "Input MB" ,
  TRUNC(OUTPUT_BYTES/1024/1024) "Output MB" ,
  TIME_TAKEN_DISPLAY "TIME_TAKEN"
FROM RC_RMAN_BACKUP_JOB_DETAILS
WHERE DB_NAME='$db'
ORDER BY start_time;

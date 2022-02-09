set lines 180
col TABLESPACE_NAME for a10
col FILE_NAME for a90
select tablespace_name, bytes/1024/1024 GB, file_name from dba_data_files;
#CREATE TABLESPACE DATA3 DATAFILE '/u02/oradata/ORCL/data3.dbf' SIZE 10M BLOCKSIZE 8K;
#alter tablespace DATA3 add datafile '/u02/oradata/ORCL/data4.dbf' size 10m;

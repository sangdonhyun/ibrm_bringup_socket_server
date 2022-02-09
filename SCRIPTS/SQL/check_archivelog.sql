set linesize 180 
col NAME for a100
col CREATED_TIME for a15

select name, to_char(FIRST_TIME,'MM-DD HH24:MI:ss') CREATED_TIME from v$archived_log 
where name is not null
order by 2,1

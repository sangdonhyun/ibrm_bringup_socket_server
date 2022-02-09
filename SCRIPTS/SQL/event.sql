col EVENT for a30
col CNT for 999
col MAX_WAIT for 9999
col SID for 9999
col P1-P2-P3 for a30
col sql_id for a15
set linesize 130
set pagesize 100

select event, cnt, seconds_in_wait max_wait,seq#, sid, p1||'-'||p2||'-'||p3 "P1-P2-P3" , sql_id, ROW_WAIT_OBJ# obj#
from (select  event, sid, seconds_in_wait,seq#,p1,p2,p3, sql_id, ROW_WAIT_OBJ#,
      row_number() over ( partition by event order by seconds_in_wait desc ) rn,
      count(*) over ( partition by event ) cnt
      from v$session
      where wait_class <> 'Idle' and sid <> USERENV ('SID')
     )
where rn <= 1 ;

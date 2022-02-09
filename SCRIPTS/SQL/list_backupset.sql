set linesize 200
col fname for a85
col backup_type for a11
col file_type for a12
col status for a10
col tag for a20
select a.PKEY, a.BACKUP_TYPE, nvl(b.FILE_TYPE, a.BS_TYPE) as FILE_TYPE, a.STATUS, a.FNAME, a.TAG,
to_char(a.COMPLETION_TIME, 'yyyy/mm/dd hh24:mi') COMPLETION_TIME
from v$backup_files a, (select BS_KEY,FILE_TYPE from v$backup_files where file_type
in ('CONTROLFILE') group by BS_KEY, FILE_TYPE order by BS_KEY) b
where a.FILE_TYPE='PIECE' and a.bs_key=b.bs_key(+);

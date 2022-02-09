col ARCHIVE_CHANGE_No for a20
select TO_CHAR(archivelog_change#-1,'999999999999999') ARCHIVE_CHANGE_No from v$database;

truncate table TEST02;
truncate table TEST03;
alter session enable parallel DML;
insert /*+ APPEND */ into TEST02 select /*+ PARALLEL(16) */ * from nolog;
commit;
insert /*+ APPEND */ into TEST02 select /*+ PARALLEL(16) */ * from nolog;
commit;
insert /*+ APPEND */ into TEST03 select /*+ PARALLEL(16) */ * from nolog;
commit;
insert /*+ APPEND */ into TEST03 select /*+ PARALLEL(16) */ * from nolog;
commit;


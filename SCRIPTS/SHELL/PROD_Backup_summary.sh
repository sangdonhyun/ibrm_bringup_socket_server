echo ""																				     > ${BACKUP_ARCH_DIR1}/1.Backup_summary.log
echo "*************************************************************************************************************************************************************" >> ${BACKUP_ARCH_DIR1}/1.Backup_summary.log
echo " [ ${DB_NAME} ] List of RMAN Backup Report  " 											     		     >> ${BACKUP_ARCH_DIR1}/1.Backup_summary.log
echo "*************************************************************************************************************************************************************" >> ${BACKUP_ARCH_DIR1}/1.Backup_summary.log
sqlplus -s / as sysdba << EOF 								    >> ${BACKUP_ARCH_DIR1}/1.Backup_summary.log
@/${SQLDIR}/rman_history_log.sql
EOF

echo "*******************************************"      >> ${BACKUP_ARCH_DIR1}/1.Backup_summary.log
echo " Total Disk Capacity Allocated to Database  "     >> ${BACKUP_ARCH_DIR1}/1.Backup_summary.log
echo "*******************************************"      >> ${BACKUP_ARCH_DIR1}/1.Backup_summary.log

sqlplus -s / as sysdba << EOF                           >> ${BACKUP_ARCH_DIR1}/1.Backup_summary.log
set feedback off
col "Total_Datafile(GB)" for 999,999,999.99
select sum(bytes)/1024/1024/1024 as "Total_Datafile(GB)" from dba_data_files;
EOF

echo "*******************************************"      >> ${BACKUP_ARCH_DIR1}/1.Backup_summary.log
echo " Total Capacity of Data in use             "      >> ${BACKUP_ARCH_DIR1}/1.Backup_summary.log
echo "*******************************************"      >> ${BACKUP_ARCH_DIR1}/1.Backup_summary.log

sqlplus -s / as sysdba << EOF                           >> ${BACKUP_ARCH_DIR1}/1.Backup_summary.log
col "Segment_Used(GB)" for 999,999,999.99
select sum(bytes)/1024/1024/1024 as "Segment_Used(GB)" from dba_segments;
EOF

echo "*************************************************************************************************************************************************************" >> ${BACKUP_ARCH_DIR1}/1.Backup_summary.log
echo " List of Online Redo log & Archive Log creation information since ${Arch_history} " 									     >> ${BACKUP_ARCH_DIR1}/1.Backup_summary.log
echo "*************************************************************************************************************************************************************" >> ${BACKUP_ARCH_DIR1}/1.Backup_summary.log
sqlplus -s / as sysdba << EOF                                                               >> ${BACKUP_ARCH_DIR1}/1.Backup_summary.log

set pages 100
set lines 200
set feedback off
col member for a100
col status for a10
col ARCHIVE_LOG_NAME for a110
col CREATOR for a8
col CREATE_DATE for a20

select a.group#, b.sequence#, a.member, b.bytes/1024/1024 MB, b.archived, b.status, b.first_change#
	from v\$logfile a , v\$log b
	where a.group#=b.group#
	order by 1;

select distinct SEQUENCE# as SEQUENCE_No, name as ARCHIVE_LOG_NAME, CREATOR, to_char(COMPLETION_TIME, 'yyyy/mm/dd hh24:mi:ss') as create_date from gv\$archived_log
       where to_char(COMPLETION_TIME, 'yyyymmdd') >= ${Arch_history}
       order by SEQUENCE_No;
EOF

echo "**********************************************************************************************" >> ${BACKUP_ARCH_DIR1}/1.Backup_summary.log
echo " List of Table Space & Datafiles ( RMAN> report schema )" 			              >> ${BACKUP_ARCH_DIR1}/1.Backup_summary.log
echo "**********************************************************************************************" >> ${BACKUP_ARCH_DIR1}/1.Backup_summary.log

rman target / nocatalog  << EOF 							              >> ${BACKUP_ARCH_DIR1}/1.Backup_summary.log
report schema;
EOF

echo "**********************************************************************************************" >> ${BACKUP_ARCH_DIR1}/1.Backup_summary.log
echo " List of newly created data files since ${TSChange} " 				              >> ${BACKUP_ARCH_DIR1}/1.Backup_summary.log
echo "**********************************************************************************************" >> ${BACKUP_ARCH_DIR1}/1.Backup_summary.log

sqlplus -s / as sysdba << EOF 								              >> ${BACKUP_ARCH_DIR1}/1.Backup_summary.log
set pages 100
set lines 200
col TABLESPACE_NAME for a30
col DATAFILE_NAME for a140
col SIZE for a12
col CREATION_TIME for a20

select TABLESPACE_NAME, NAME as DATAFILE_NAME, to_char(BYTES/1024/1024) || ' MB' "SIZE",
        to_char(CREATION_TIME, 'yyyy/mm/dd hh24:mi:ss') as CREATION_TIME from v\$datafile_header
        where to_char(CREATION_TIME, 'yyyymmdd') >= ${TSChange}
        order by CREATION_TIME;
EOF

echo "**********************************************************************************************" >> ${BACKUP_ARCH_DIR1}/1.Backup_summary.log
echo " Incarnation information of Database  " 				   		              >> ${BACKUP_ARCH_DIR1}/1.Backup_summary.log
echo "**********************************************************************************************" >> ${BACKUP_ARCH_DIR1}/1.Backup_summary.log

rman target / nocatalog  << EOF                                                                       >> ${BACKUP_ARCH_DIR1}/1.Backup_summary.log
list incarnation of database;
EOF

echo "**********************************************************************************************" >> ${BACKUP_ARCH_DIR1}/1.Backup_summary.log
echo " Information of Disk usage & Data Capacity " 			                              >> ${BACKUP_ARCH_DIR1}/1.Backup_summary.log
echo "**********************************************************************************************" >> ${BACKUP_ARCH_DIR1}/1.Backup_summary.log
echo "Filesystem                  Type     Size Used  Avail Use% Mounted on                "          >> ${BACKUP_ARCH_DIR1}/1.Backup_summary.log
df -PhT |grep ${DB_DIR} |sort -k7                                                                     >> ${BACKUP_ARCH_DIR1}/1.Backup_summary.log
echo "**********************************************************************************************" >> ${BACKUP_ARCH_DIR1}/1.Backup_summary.log
cp ${BACKUP_ARCH_DIR1}/1.Backup_summary.log ${BACKUPDB_LOGDIR}/${DB_DIR}_Backup_Summary_${YMDH}.log

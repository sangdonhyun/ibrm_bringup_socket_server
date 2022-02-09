echo "********************************************************************************************************************"     >> ${CLONEDB_Recover_LOG}
echo "Start create trace controlfile for inventory unnamed datafile !!"  							>> ${CLONEDB_Recover_LOG}
if [ -f ${DBADIR}/trace_control.sql ]
then
rm -f ${DBADIR}/trace_control.sql
fi

#rman target / nocatalog  << EOF >> ${CLONEDB_Recover_LOG}
sqlplus -s / as sysdba << EOF >> ${CLONEDB_Recover_LOG}
alter database backup controlfile to trace as '${DBADIR}/trace_control.sql';
EOF

cat ${CLONEDB_LOG}/1.Datafile_history.log											>> ${CLONEDB_Recover_LOG}

sqlplus -s / as sysdba << EOF 												 	>> ${CLONEDB_Recover_LOG}	
set lines 200
col "TS#" for 999
col tbs_name for a20
col file_name for a110
col file_size for a11
col status for a10

select t.TS#, t.name tbs_name, f.name file_name, round(f.bytes / 1024 / 1024 ) || ' MB' "FILE_SIZE",f.status, f.checkpoint_change# checkpoint#
from v\$datafile f, v\$tablespace t where f.TS#=t.TS#
order by t.TS#;
EOF

echo ""                                                                                                                         >> ${CLONEDB_Recover_LOG}
echo "----------------------------------------------------------------------------------------------------------------------"   >> ${CLONEDB_Recover_LOG}
echo "If you found that UNNAMED datafile line in the FILE_NAME columm then execute below command to create datafile"            >> ${CLONEDB_Recover_LOG}
echo "SYS@CLONEDB> alter database create datafile '/UNNAMED_FILE_LOCATION/FILE_NAME' as '/NEW_FILE_LOCATION/NEW_FILE_NAME';"    >> ${CLONEDB_Recover_LOG}
echo "**********************************************************************************************************************"   >> ${CLONEDB_Recover_LOG}
echo "**[ End of Step 3 ]***************************************************************************************************"   >> ${CLONEDB_Recover_LOG}

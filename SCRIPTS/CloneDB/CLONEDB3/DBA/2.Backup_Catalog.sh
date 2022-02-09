if [ ! -d ${CLONEDB_LOG} ]
then
mkdir -p ${CLONEDB_LOG}
fi
touch ${CLONEDB_Recover_LOG}
echo "Start ${ORACLE_SID} Catalogging !! : `date '+%F_%H:%M:%S'`" >> ${CLONEDB_Recover_LOG}

rman target / nocatalog  << EOF >> ${CLONEDB_Recover_LOG}
catalog start with '${CLONE_ARCH_DIR1}' noprompt;
catalog start with '${CLONE_ARCH_DIR2}' noprompt;

EOF

echo "Cataloging has been Finished from Backup Files : `date '+%F_%H:%M:%S'`" 							>> ${CLONEDB_Recover_LOG}
echo "**[ End of Step 2 ]*************************************************************************************************"     >> ${CLONEDB_Recover_LOG}

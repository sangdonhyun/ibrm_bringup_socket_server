SQN=$1
echo " Start Sequence based Recovery !! : `date '+%F_%H:%M:%S'`" >> $CLONEDB_Recover_LOG
rman target /  << EOF >> $CLONEDB_Recover_LOG
run {
   ALLOCATE CHANNEL CH01 TYPE DISK;
   ALLOCATE CHANNEL CH02 TYPE DISK;
   ALLOCATE CHANNEL CH03 TYPE DISK;
   ALLOCATE CHANNEL CH04 TYPE DISK;

     set until sequence=${SQN};
     recover database;
}
exit;
EOF

echo ""                                                                                                                         >> ${CLONEDB_Recover_LOG}
echo "**[ Please wait until creating redo log files to open CLONE DB ]****************************************************"     >> ${CLONEDB_Recover_LOG}
echo "**[ Check the status of the CLONE DB after the recovery is complete. ]**********************************************"     >> ${CLONEDB_Recover_LOG}
echo ""                                                                                                                         >> ${CLONEDB_Recover_LOG}

sqlplus -s / as sysdba << EOF >> $CLONEDB_Recover_LOG

ALTER DATABASE OPEN RESETLOGS;
ALTER TABLESPACE TEMP ADD TEMPFILE '${CLONE_TEMP}' SIZE 20971520  REUSE AUTOEXTEND ON NEXT 655360  MAXSIZE 32767M;
select instance_name, status from v\$instance;
EOF

echo " Sequence based Recovery has been Finished : `date '+%F_%H:%M:%S'`" >> $CLONEDB_Recover_LOG
echo ""                                                                                                                         >> ${CLONEDB_Recover_LOG}
echo "**[ End of Step 4 ]*************************************************************************************************"     >> ${CLONEDB_Recover_LOG}

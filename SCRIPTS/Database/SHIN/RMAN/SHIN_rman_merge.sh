#!/bin/bash
DB_DIR=$1
. /ZFS/SCRIPTS/Database/${DB_DIR}/ZFS_Profile

if [ ! -d ${BACKUPDB_LOGDIR} ]
   then

     mkdir -p ${BACKUPDB_LOGDIR}
fi

echo "-------------------------------------------------------------------------------------------------------" 	
echo " Step 2 : Starting RMAN Incremental Merge process                              [`date '+%F %H:%M:%S'`] " 	>> $SHELL_LOG
echo "-------------------------------------------------------------------------------------------------------" 	>> $RMAN_Merge_LOG

sh ${SHELLDIR}/run_ch_latency_backup.sh
echo " ZFS has been changed to Latency mode                                          [`date '+%F %H:%M:%S'`] "	>> $RMAN_Merge_LOG
echo "-------------------------------------------------------------------------------------------------------" 	>> $RMAN_Merge_LOG

export BACKUP_TIME=`date +%Y/%m/%d_%H:%M:%S`
echo "$BACKUP_TIME" > /${ZFS_TEMP_DIR}/${DB_NAME}_MTIME.out

### You can select BKLEV : Full / Level0 / Level1 / Merge ####
echo "Merge" > /${ZFS_TEMP_DIR}/${DB_NAME}_BKLEV.out

#rman target / nocatalog << EOF >> $RMAN_Merge_LOG
rman target / catalog $2/$3@$4 << EOF >> $RMAN_Merge_LOG
resync catalog;

run
{
#sql 'alter system set "_backup_disk_bufcnt" = 64      scope=memory';
#sql 'alter system set "_backup_disk_bufsz"  = 1048576 scope=memory';
#sql 'alter system set "_backup_file_bufcnt" = 64      scope=memory';
#sql 'alter system set "_backup_file_bufsz"  = 1048576 scope=memory';

ALLOCATE CHANNEL MCH01 TYPE DISK FORMAT '${BACKUP_DATA_DIR1}/DCH1/%U';
ALLOCATE CHANNEL MCH02 TYPE DISK FORMAT '${BACKUP_DATA_DIR2}/DCH2/%U';
ALLOCATE CHANNEL MCH03 TYPE DISK FORMAT '${BACKUP_DATA_DIR1}/DCH3/%U';
ALLOCATE CHANNEL MCH04 TYPE DISK FORMAT '${BACKUP_DATA_DIR2}/DCH4/%U';
ALLOCATE CHANNEL MCH05 TYPE DISK FORMAT '${BACKUP_DATA_DIR1}/DCH5/%U';
ALLOCATE CHANNEL MCH06 TYPE DISK FORMAT '${BACKUP_DATA_DIR2}/DCH6/%U';
ALLOCATE CHANNEL MCH07 TYPE DISK FORMAT '${BACKUP_DATA_DIR1}/DCH7/%U';
ALLOCATE CHANNEL MCH08 TYPE DISK FORMAT '${BACKUP_DATA_DIR2}/DCH8/%U';

RECOVER COPY OF DATABASE WITH TAG '${RMAN_TAG_INCR}';

RELEASE CHANNEL MCH01;
RELEASE CHANNEL MCH02;
RELEASE CHANNEL MCH03;
RELEASE CHANNEL MCH04;
RELEASE CHANNEL MCH05;
RELEASE CHANNEL MCH06;
RELEASE CHANNEL MCH07;
RELEASE CHANNEL MCH08;

CROSSCHECK BACKUPPIECE TAG '${RMAN_TAG_INCR}';
DELETE NOPROMPT EXPIRED BACKUPSET TAG '${RMAN_TAG_INCR}';
}
exit
EOF

echo "          RMAN Incremental Merge Backup has been finished                      [`date '+%F %H:%M:%S'`] "  >> $SHELL_LOG
echo "-------------------------------------------------------------------------------------------------------"  >> $SHELL_LOG

Sleep 30

echo "======= Creating a list of backup data files for creating cloneDB control file ======================================"
rman target / nocatalog  << EOF > /${ZFS_TEMP_DIR}/${DB_NAME}_backuplist.out
LIST COPY TAG $RMAN_TAG_INCR completed after "to_date('$BACKUP_TIME','yyyy/mm/dd_hh24:mi:ss')";
EOF

cat /${ZFS_TEMP_DIR}/${DB_NAME}_backuplist.out |grep Name |grep -v "Container ID" |awk '{print $2}' > ${BACKUP_DATA_DIR1}/list_data.out

echo "=========== Report daily backup results ============================================================================="
 sh  $SHELLDIR/Daily_Backup_result_log.sh > ${LOGDIR}/Daily_Backup_result.txt

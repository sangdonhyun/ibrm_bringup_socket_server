#!/bin/bash
DB_DIR=$1
. /ZFS/SCRIPTS/Database/${DB_DIR}/ZFS_Profile

if [ ! -d ${BACKUPDB_LOGDIR} ]
   then

     mkdir -p ${BACKUPDB_LOGDIR}
fi

echo "======================================================================================================="	>  $RMAN_L1_LOG
echo " *** Starting delete previous Incremental Backup Pieces                        [`date '+%F %H:%M:%S'`] " 	>> $RMAN_L1_LOG

rm ${BACKUP_DATA_DIR1}/DCH1/*_1_1 &
rm ${BACKUP_DATA_DIR2}/DCH2/*_1_1 &
rm ${BACKUP_DATA_DIR1}/DCH3/*_1_1 &
rm ${BACKUP_DATA_DIR2}/DCH4/*_1_1 &
rm ${BACKUP_DATA_DIR1}/DCH5/*_1_1 &
rm ${BACKUP_DATA_DIR2}/DCH6/*_1_1 &
rm ${BACKUP_DATA_DIR1}/DCH7/*_1_1 &
rm ${BACKUP_DATA_DIR2}/DCH8/*_1_1 &
wait

echo " *** Delete previous Incremental Backup Pieces has been completed              [`date '+%F %H:%M:%S'`] "  >> $RMAN_L1_LOG
echo "=======================================================================================================" 	>> $RMAN_L1_LOG
echo "-------------------------------------------------------------------------------------------------------" 	>> $SHELL_LOG
echo " Step 1 : Starting RMAN Incremental Level 1 Backup                             [`date '+%F %H:%M:%S'`] "	>> $SHELL_LOG
echo "-------------------------------------------------------------------------------------------------------" 	>> $RMAN_L1_LOG

sh ${SHELLDIR}/run_ch_throughput_backup.sh
echo " ZFS has been changed to Throughput mod                                        [`date '+%F %H:%M:%S'`] "	>> $RMAN_L1_LOG
echo "-------------------------------------------------------------------------------------------------------" 	>> $RMAN_L1_LOG

echo " Estimated incremental backup size " 									>> $RMAN_L1_LOG
sh ${SHELLDIR}/est_incr_backup.sh 										>> $RMAN_L1_LOG

export BACKUP_TIME=`date +%Y/%m/%d_%H:%M:%S`
echo "$BACKUP_TIME" > /${ZFS_TEMP_DIR}/${DB_NAME}_STIME.out
echo "$BACKUP_TIME" > /${ZFS_TEMP_DIR}/${DB_NAME}_L1TIME.out

### You can select BKLEV : Full / Level0 / Level1 / Merge ####
echo "Level1" > /${ZFS_TEMP_DIR}/${DB_NAME}_BKLEV.out

rman target / nocatalog << EOF 											 >> $RMAN_L1_LOG
#rman target / catalog $2/$3@$4 << EOF 										 >> $RMAN_L1_LOG
#resync catalog;

run
{
#sql 'alter system set "_backup_disk_bufcnt" = 64    scope=memory';
#sql 'alter system set "_backup_disk_bufsz" = 1048576 scope=memory';
#sql 'alter system set "_backup_file_bufcnt" = 64    scope=memory';
#sql 'alter system set "_backup_file_bufsz" = 1048576 scope=memory';

ALLOCATE CHANNEL ICH01 TYPE DISK FORMAT '${BACKUP_DATA_DIR1}/DCH1/%U';
ALLOCATE CHANNEL ICH02 TYPE DISK FORMAT '${BACKUP_DATA_DIR2}/DCH2/%U';
ALLOCATE CHANNEL ICH03 TYPE DISK FORMAT '${BACKUP_DATA_DIR1}/DCH3/%U';
ALLOCATE CHANNEL ICH04 TYPE DISK FORMAT '${BACKUP_DATA_DIR2}/DCH4/%U';
ALLOCATE CHANNEL ICH05 TYPE DISK FORMAT '${BACKUP_DATA_DIR1}/DCH5/%U';
ALLOCATE CHANNEL ICH06 TYPE DISK FORMAT '${BACKUP_DATA_DIR2}/DCH6/%U';
ALLOCATE CHANNEL ICH07 TYPE DISK FORMAT '${BACKUP_DATA_DIR1}/DCH7/%U';
ALLOCATE CHANNEL ICH08 TYPE DISK FORMAT '${BACKUP_DATA_DIR2}/DCH8/%U';

BACKUP INCREMENTAL LEVEL 1 FILESPERSET 1 FOR RECOVER OF COPY TAG '${RMAN_TAG_INCR}' DATABASE REUSE;

RELEASE CHANNEL ICH01;
RELEASE CHANNEL ICH02;
RELEASE CHANNEL ICH03;
RELEASE CHANNEL ICH04;
RELEASE CHANNEL ICH05;
RELEASE CHANNEL ICH06;
RELEASE CHANNEL ICH07;
RELEASE CHANNEL ICH08;

BACKUP AS COPY CURRENT CONTROLFILE TAG 'CTRL_COPY' FORMAT '${BACKUP_DATA_DIR1}/control_backup.ctl' REUSE;

}
exit
EOF

echo "          RMAN Incremental level 1 Backup has been finished                    [`date '+%F %H:%M:%S'`] " 	>> $SHELL_LOG
echo "-------------------------------------------------------------------------------------------------------" 	>> $SHELL_LOG

echo "========= Report daily backup results ================================================================="
 sh  ${SQLDIR}/Daily_Backup_result_log.sh > ${LOGDIR}/Daily_Backup_result.txt
echo "=======================================================================================================" >> $RMAN_L1_LOG

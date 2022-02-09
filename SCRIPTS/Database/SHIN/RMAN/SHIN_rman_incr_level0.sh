#!/bin/bash
DB_DIR=$1
. /ZFS/SCRIPTS/Database/${DB_DIR}/ZFS_Profile

echo "=========================================================================================================" > $RMAN_L0_LOG
if [ ! -d ${BACKUPDB_LOGDIR} ]
   then
     mkdir -p ${BACKUPDB_LOGDIR}
fi

echo "=========================================================================================================" >> $RMAN_L0_LOG
echo " *** Start deleting all data files ***                                           [`date '+%F %H:%M:%S'`] " >> $RMAN_L0_LOG
echo "---------------------------------------------------------------------------------------------------------" >> $RMAN_L0_LOG

#/bin/rsync -a --delete /ZFS/SCRIPTS/SHELL/Blank_dir/ ${BACKUP_DATA_DIR1}/DCH1/ &
#/bin/rsync -a --delete /ZFS/SCRIPTS/SHELL/Blank_dir/ ${BACKUP_DATA_DIR2}/DCH2/ &
#/bin/rsync -a --delete /ZFS/SCRIPTS/SHELL/Blank_dir/ ${BACKUP_DATA_DIR1}/DCH3/ &
#/bin/rsync -a --delete /ZFS/SCRIPTS/SHELL/Blank_dir/ ${BACKUP_DATA_DIR2}/DCH4/ &
#/bin/rsync -a --delete /ZFS/SCRIPTS/SHELL/Blank_dir/ ${BACKUP_DATA_DIR1}/DCH5/ &
#/bin/rsync -a --delete /ZFS/SCRIPTS/SHELL/Blank_dir/ ${BACKUP_DATA_DIR2}/DCH6/ &
#/bin/rsync -a --delete /ZFS/SCRIPTS/SHELL/Blank_dir/ ${BACKUP_DATA_DIR1}/DCH7/ &
#/bin/rsync -a --delete /ZFS/SCRIPTS/SHELL/Blank_dir/ ${BACKUP_DATA_DIR2}/DCH8/ &

rm -f ${BACKUP_DATA_DIR1}/DCH1/* &
rm -f ${BACKUP_DATA_DIR2}/DCH2/* &
rm -f ${BACKUP_DATA_DIR1}/DCH3/* &
rm -f ${BACKUP_DATA_DIR2}/DCH4/* &
rm -f ${BACKUP_DATA_DIR1}/DCH5/* &
rm -f ${BACKUP_DATA_DIR2}/DCH6/* &
rm -f ${BACKUP_DATA_DIR1}/DCH7/* &
rm -f ${BACKUP_DATA_DIR2}/DCH8/* &
wait

echo " *** All data files have been deleted ***	                                       [`date '+%F %H:%M:%S'`] " >> $RMAN_L0_LOG
echo "=========================================================================================================" >> $RMAN_L0_LOG

sh ${SHELLDIR}/run_ch_throughput_backup.sh
echo " *** ZFS has been changed to throughput mode *** 	                               [`date '+%F %H:%M:%S'`] " >> $RMAN_L0_LOG
echo "---------------------------------------------------------------------------------------------------------" >> $RMAN_L0_LOG

export BACKUP_TIME=`date +%Y/%m/%d_%H:%M:%S`
echo "$BACKUP_TIME" > /${ZFS_TEMP_DIR}/${DB_NAME}_STIME.out
echo "$BACKUP_TIME" > /${ZFS_TEMP_DIR}/${DB_NAME}_L0TIME.out

### You can select BKLEV : Full / Level0 / Level1 / Merge ####
echo "Level0" > /${ZFS_TEMP_DIR}/${DB_NAME}_BKLEV.out

#rman target / nocatalog << EOF >> $RMAN_L0_LOG
rman target / catalog $2/$3@$4 << EOF >> $RMAN_L0_LOG
resync catalog;

run
{

#sql 'alter system set "_backup_disk_bufcnt" = 64 scope=memory';
#sql 'alter system set "_backup_disk_bufsz" = 1048576 scope=memory';
#sql 'alter system set "_backup_file_bufcnt" = 64 scope=memory';
#sql 'alter system set "_backup_file_bufsz" = 1048576 scope=memory';

#ALLOCATE CHANNEL DCH01 TYPE DISK CONNECT 'sys/"Welcome1!"@10.179.94.212:1521/LABDB' FORMAT '${BACKUP_DATA_DIR1}/DCH1/%U';

ALLOCATE CHANNEL DCH01 TYPE DISK FORMAT '${BACKUP_DATA_DIR1}/DCH1/%U';
ALLOCATE CHANNEL DCH02 TYPE DISK FORMAT '${BACKUP_DATA_DIR2}/DCH2/%U';
ALLOCATE CHANNEL DCH03 TYPE DISK FORMAT '${BACKUP_DATA_DIR1}/DCH3/%U';
ALLOCATE CHANNEL DCH04 TYPE DISK FORMAT '${BACKUP_DATA_DIR2}/DCH4/%U';
ALLOCATE CHANNEL DCH05 TYPE DISK FORMAT '${BACKUP_DATA_DIR1}/DCH5/%U';
ALLOCATE CHANNEL DCH06 TYPE DISK FORMAT '${BACKUP_DATA_DIR2}/DCH6/%U';
ALLOCATE CHANNEL DCH07 TYPE DISK FORMAT '${BACKUP_DATA_DIR1}/DCH7/%U';
ALLOCATE CHANNEL DCH08 TYPE DISK FORMAT '${BACKUP_DATA_DIR2}/DCH8/%U';

BACKUP AS COPY INCREMENTAL LEVEL 0 TAG '${RMAN_TAG_INCR}' DATABASE REUSE;

RELEASE CHANNEL DCH01;
RELEASE CHANNEL DCH02;
RELEASE CHANNEL DCH03;
RELEASE CHANNEL DCH04;
RELEASE CHANNEL DCH05;
RELEASE CHANNEL DCH06;
RELEASE CHANNEL DCH07;
RELEASE CHANNEL DCH08;

CROSSCHECK DATAFILECOPY TAG '${RMAN_TAG_INCR}';
DELETE NOPROMPT EXPIRED DATAFILECOPY TAG '${RMAN_TAG_INCR}';

BACKUP AS COPY CURRENT CONTROLFILE TAG 'CTRL_COPY' FORMAT '${BACKUP_DATA_DIR1}/control_backup.ctl' REUSE;

}
exit
EOF

sh ${SHELLDIR}/get_SCN.sh > ${BACKUP_ARCH_DIR1}/2.SCN_number.txt

sleep 30

echo "======= Make a list of backed up datafiles for Clone DB control file making ========================================="
rman target / nocatalog  << EOF > /${ZFS_TEMP_DIR}/${DB_NAME}_backuplist.out
LIST COPY TAG $RMAN_TAG_INCR completed after "to_date('$BACKUP_TIME','yyyy/mm/dd_hh24:mi:ss')";
EOF

cat /${ZFS_TEMP_DIR}/${DB_NAME}_backuplist.out |grep Name |grep -v "Container ID" |awk '{print $2}' > ${BACKUP_DATA_DIR1}/list_data.out
echo "====================================================================================================================="

echo "======== Report daily backup results ================================================================================"
 sh  ${SQLDIR}/Daily_Backup_result_log.sh > ${LOGDIR}/Daily_Backup_result.txt
echo "====================================================================================================================="

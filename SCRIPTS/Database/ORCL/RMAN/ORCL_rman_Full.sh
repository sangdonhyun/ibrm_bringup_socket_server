#!/bin/sh
DB_DIR=ORCL
. /ZFS/SCRIPTS/Database/${DB_DIR}/ZFS_Profile

echo "=========================================================================================================" > $RMAN_FULL_LOG
if [ ! -d ${BACKUPDB_LOGDIR} ]
   then
     mkdir -p ${BACKUPDB_LOGDIR}
fi

echo "=========================================================================================================" >> $RMAN_FULL_LOG
echo " Start all of datafile deletion                                                  [`date '+%F %H:%M:%S'`] " >> $RMAN_FULL_LOG
echo "---------------------------------------------------------------------------------------------------------" >> $RMAN_FULL_LOG

rm -f ${BACKUP_DATA_DIR1}/DCH1/* &
rm -f ${BACKUP_DATA_DIR2}/DCH2/* &
rm -f ${BACKUP_DATA_DIR1}/DCH3/* &
rm -f ${BACKUP_DATA_DIR2}/DCH4/* &
rm -f ${BACKUP_DATA_DIR1}/DCH5/* &
rm -f ${BACKUP_DATA_DIR2}/DCH6/* &
rm -f ${BACKUP_DATA_DIR1}/DCH7/* &
rm -f ${BACKUP_DATA_DIR2}/DCH8/* &

wait
echo " All of datafile has been deleted                                                [`date '+%F %H:%M:%S'`] " >> $RMAN_FULL_LOG
echo "=========================================================================================================" >> $RMAN_FULL_LOG

${SHELL} ${SHELLDIR}/run_ch_throughput_backup.sh
echo "ZFS has been changed to throughput mode                                          [`date '+%F %H:%M:%S'`] " >> $RMAN_FULL_LOG
echo "---------------------------------------------------------------------------------------------------------" >> $RMAN_FULL_LOG

export BACKUP_TIME=`date +%Y/%m/%d_%H:%M:%S`
echo "$BACKUP_TIME" > /${ZFS_TEMP_DIR}/${DB_NAME}_FTIME.out
echo "$BACKUP_TIME" > /${ZFS_TEMP_DIR}/${DB_NAME}_STIME.out

### You can select BKLEV : Full / Level0 / Level1 / Merge ####
echo "Full" > /${ZFS_TEMP_DIR}/${DB_NAME}_BKLEV.out

rman target / nocatalog << EOF >> $RMAN_FULL_LOG
#rman target / catalog $2/$3@$4 << EOF >> $RMAN_FULL_LOG
#resync catalog;

run
{

#sql 'alter system set "_backup_disk_bufcnt" = 64 scope=memory';
#sql 'alter system set "_backup_disk_bufsz" = 1048576 scope=memory';
#sql 'alter system set "_backup_file_bufcnt" = 64 scope=memory';
#sql 'alter system set "_backup_file_bufsz" = 1048576 scope=memory';

#ALLOCATE CHANNEL FCH01 TYPE DISK CONNECT 'sys/"Welcome1!"@10.179.94.212:1521/LABDB' FORMAT '${BACKUP_DATA_DIR1}/DCH1/%U';

ALLOCATE CHANNEL FCH01 TYPE DISK FORMAT '${BACKUP_DATA_DIR1}/DCH1/%U';
ALLOCATE CHANNEL FCH02 TYPE DISK FORMAT '${BACKUP_DATA_DIR2}/DCH2/%U';
ALLOCATE CHANNEL FCH03 TYPE DISK FORMAT '${BACKUP_DATA_DIR1}/DCH3/%U';
ALLOCATE CHANNEL FCH04 TYPE DISK FORMAT '${BACKUP_DATA_DIR2}/DCH4/%U';
ALLOCATE CHANNEL FCH05 TYPE DISK FORMAT '${BACKUP_DATA_DIR1}/DCH5/%U';
ALLOCATE CHANNEL FCH06 TYPE DISK FORMAT '${BACKUP_DATA_DIR2}/DCH6/%U';
ALLOCATE CHANNEL FCH07 TYPE DISK FORMAT '${BACKUP_DATA_DIR1}/DCH7/%U';
ALLOCATE CHANNEL FCH08 TYPE DISK FORMAT '${BACKUP_DATA_DIR2}/DCH8/%U';

BACKUP AS COPY FULL DATABASE TAG '${RMAN_TAG_FULL}';

RELEASE CHANNEL FCH01;
RELEASE CHANNEL FCH02;
RELEASE CHANNEL FCH03;
RELEASE CHANNEL FCH04;
RELEASE CHANNEL FCH05;
RELEASE CHANNEL FCH06;
RELEASE CHANNEL FCH07;
RELEASE CHANNEL FCH08;

CROSSCHECK DATAFILECOPY TAG '${RMAN_TAG_FULL}';
DELETE NOPROMPT EXPIRED DATAFILECOPY TAG '${RMAN_TAG_FULL}';

BACKUP AS COPY CURRENT CONTROLFILE TAG 'CTRL_COPY' FORMAT '${BACKUP_DATA_DIR1}/control_backup.ctl' REUSE;

}
exit
EOF

${SHELL} ${SHELLDIR}/get_SCN.sh > ${BACKUP_ARCH_DIR1}/2.SCN_number.txt

sleep 30

echo "======= Make a list of backed up datafiles for Clone DB control file making ========================================="
rman target / nocatalog  << EOF > /${ZFS_TEMP_DIR}/${DB_NAME}_backuplist.out
LIST COPY TAG $RMAN_TAG_FULL completed after "to_date('$BACKUP_TIME','yyyy/mm/dd_hh24:mi:ss')";
EOF

cat /${ZFS_TEMP_DIR}/${DB_NAME}_backuplist.out |grep Name |grep -v "Container ID" |awk '{print $2}' > ${BACKUP_DATA_DIR1}/list_data.out
echo "====================================================================================================================="

echo "======== Report daily backup results ================================================================================"
${SHELL}  ${SQLDIR}/Daily_Backup_result_log.sh > ${LOGDIR}/Daily_Backup_result.txt
echo "====================================================================================================================="


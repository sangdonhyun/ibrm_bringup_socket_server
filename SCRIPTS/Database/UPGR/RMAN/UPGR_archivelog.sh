#!/bin/bash
DB_DIR=$1
. /ZFS/SCRIPTS/Database/${DB_DIR}/ZFS_Profile

echo "========================================================================================================================================" > $Arch_LOG

     mkdir -p ${BACKUPDB_LOGDIR}
     mkdir -p ${BACKUP_ARCH_DIR1}/${DB_NAME}_${YMD}
     mkdir -p ${BACKUP_ARCH_DIR2}/${DB_NAME}_${YMD}

echo "-------------------------------------------------------------------------------------------------------" 

echo " *** Crosscheck will delete archivelogs in the RMAN Catalog *** "                          >> $Arch_LOG

rman target / nocatalog << EOF                                                                   >> $Arch_LOG
#rman target / catalog $2/$3@$4 << EOF                                                           >> $Arch_LOG
#resync catalog;

run
{

### Archive Log switch in the RAC environment ###
#sql 'ALTER SYSTEM ARCHIVE LOG CURRENT';

### Archive Log switch in the non-RAC environment ###
sql 'ALTER SYSTEM SWITCH LOGFILE';

#ALLOCATE CHANNEL ACH01 TYPE DISK CONNECT 'sys/"Welcome1!"@10.179.94.212:1521/LABDB' FORMAT '${BACKUP_ARCH_DIR1}/${DB_NAME}_${YMD}/arch_%d_%h_%e_%r_%u.arc';

ALLOCATE CHANNEL ACH01 TYPE DISK FORMAT '${BACKUP_ARCH_DIR1}/${DB_NAME}_${YMD}/arch_%d_%h_%e_%r_%u.arc';
ALLOCATE CHANNEL ACH02 TYPE DISK FORMAT '${BACKUP_ARCH_DIR2}/${DB_NAME}_${YMD}/arch_%d_%h_%e_%r_%u.arc';
ALLOCATE CHANNEL ACH03 TYPE DISK FORMAT '${BACKUP_ARCH_DIR1}/${DB_NAME}_${YMD}/arch_%d_%h_%e_%r_%u.arc';
ALLOCATE CHANNEL ACH04 TYPE DISK FORMAT '${BACKUP_ARCH_DIR2}/${DB_NAME}_${YMD}/arch_%d_%h_%e_%r_%u.arc';
ALLOCATE CHANNEL ACH05 TYPE DISK FORMAT '${BACKUP_ARCH_DIR1}/${DB_NAME}_${YMD}/arch_%d_%h_%e_%r_%u.arc';
ALLOCATE CHANNEL ACH06 TYPE DISK FORMAT '${BACKUP_ARCH_DIR2}/${DB_NAME}_${YMD}/arch_%d_%h_%e_%r_%u.arc';
ALLOCATE CHANNEL ACH07 TYPE DISK FORMAT '${BACKUP_ARCH_DIR1}/${DB_NAME}_${YMD}/arch_%d_%h_%e_%r_%u.arc';
ALLOCATE CHANNEL ACH08 TYPE DISK FORMAT '${BACKUP_ARCH_DIR2}/${DB_NAME}_${YMD}/arch_%d_%h_%e_%r_%u.arc';

#BACKUP AS COPY ARCHIVELOG ALL;
#BACKUP AS COPY ARCHIVELOG FROM TIME 'SYSDATE-1' DELETE INPUT;

BACKUP AS COPY ARCHIVELOG ALL;

RELEASE CHANNEL ACH01;
RELEASE CHANNEL ACH02;
RELEASE CHANNEL ACH03;
RELEASE CHANNEL ACH04;
RELEASE CHANNEL ACH05;
RELEASE CHANNEL ACH06;
RELEASE CHANNEL ACH07;
RELEASE CHANNEL ACH08;

CROSSCHECK ARCHIVELOG ALL;
DELETE NOPROMPT EXPIRED ARCHIVELOG ALL;
}
exit
EOF

echo "------------------------------------------------------------------------------------------------------------------------"

sh ${SHELLDIR}/get_SCN.sh               > ${BACKUP_ARCH_DIR1}/2.SCN_number.txt

echo "=========== Report daily backup results ================================================================================"
sh ${SQLDIR}/Daily_Backup_result_log.sh > ${LOGDIR}/Daily_Backup_result.txt

sh ${SHELLDIR}/PROD_Backup_summary.sh

echo "========================================================================================================================"
echo " *** Archive log backup has been finished                                      [`date '+%F %H:%M:%S'`] " 	>> $SHELL_LOG
echo "-------------------------------------------------------------------------------------------------------"  >> $SHELL_LOG
echo " *** Delete expired backup Archive Log files ***                               [`date '+%F %H:%M:%S'`] " 	>> $SHELL_LOG
       sh -c "${SHELLDIR}/run_del_arch_backup_data.sh     $ARCH_DIR "                              		>> $SHELL_LOG
echo "========================================================================================================================="

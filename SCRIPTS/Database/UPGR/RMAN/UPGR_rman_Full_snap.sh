#!/bin/bash
DB_DIR=$1
. /ZFS/SCRIPTS/Database/${DB_DIR}/ZFS_Profile

if [ "$RUN_USER" = "root" ]
 then
   echo " "                                                                                                        >> $Full_DataSnap_LOG
   echo "--------------------------------------------------------------------------------------------------------" >> $Full_DataSnap_LOG
          su - $ORACLE_USER -c "${SHELLDIR}/run_Full_datasnap.sh         $DB_DIR "                                 >> $Full_DataSnap_LOG

   echo " *** Full backup Data Snapshot has been created ***                             [`date '+%F %H:%M:%S'`] " >> $Full_DataSnap_LOG
   echo "--------------------------------------------------------------------------------------------------------" >> $Full_DataSnap_LOG

          su - $ORACLE_USER -c "${SHELLDIR}/run_del_Full_datasnap.sh     $DB_DIR "                                 >> $Full_DataSnap_LOG
   echo " *** Expired Backup Data Snapshots has been deleted ***                         [`date '+%F %H:%M:%S'`] " >> $Full_DataSnap_LOG
   echo "--------------------------------------------------------------------------------------------------------" >> $Full_DataSnap_LOG

          su - $ORACLE_USER -c "${SHELLDIR}/run_del_backuplog.sh         $DB_DIR"                                  >> $Full_DataSnap_LOG

          RSTAT=$?
 else
   echo " "                                                                                                       >> $Full_DataSnap_LOG
   echo "-------------------------------------------------------------------------------------------------------" >> $Full_DataSnap_LOG
          /bin/sh -c "${SHELLDIR}/run_Full_datasnap.sh       		$DB_DIR "                                 >> $Full_DataSnap_LOG

   echo " *** Full backup Data Snapshot Create has been created ***                     [`date '+%F %H:%M:%S'`] " >> $Full_DataSnap_LOG
   echo "-------------------------------------------------------------------------------------------------------" >> $Full_DataSnap_LOG

          /bin/sh -c "${SHELLDIR}/run_del_Full_datasnap.sh   		$DB_DIR "                                 >> $Full_DataSnap_LOG
   echo " *** Expired Backup Data Snapshots has been deleted ***                        [`date '+%F %H:%M:%S'`] " >> $Full_DataSnap_LOG
   echo "-------------------------------------------------------------------------------------------------------" >> $Full_DataSnap_LOG

          /bin/sh -c "${SHELLDIR}/run_del_backuplog.sh         		$DB_DIR"                                  >> $Full_DataSnap_LOG

          RSTAT=$?
 fi

if [ "$RSTAT" = "0" ]
 then
   echo "-------------------------------------------------------------------------------------------------------" >> $Full_DataSnap_LOG

 else
   echo " *** Error(s) occured during snapshot management ***                           [ CODE: $RSTAT ]        " >> $Full_DataSnap_LOG
   echo "-------------------------------------------------------------------------------------------------------" >> $Full_DataSnap_LOG
 fi

 exit $RSTAT


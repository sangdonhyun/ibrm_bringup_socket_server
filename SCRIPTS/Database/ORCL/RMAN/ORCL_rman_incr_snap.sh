#!/bin/sh
DB_DIR=ORCL
. /ZFS/SCRIPTS/Database/${DB_DIR}/ZFS_Profile

if [ "$RUN_USER" = "root" ]
 then
   echo "-------------------------------------------------------------------------------------------------------"  >> $Incr_DataSnap_LOG
   echo " *** Create Backup Data Snapshot ***                                           [`date '+%F %H:%M:%S'`] "  >> $Incr_DataSnap_LOG
   echo ""                                                                                                         >> $Incr_DataSnap_LOG
          su - $ORACLE_USER -c "${SHELLDIR}/run_Daily_datasnap.sh    	$DB_DIR               			"  >> $Incr_DataSnap_LOG

   echo "-------------------------------------------------------------------------------------------------------"  >> $Incr_DataSnap_LOG
   echo " *** Delete Expired Backup Data Snapshot ***                                   [`date '+%F %H:%M:%S'`] "  >> $Incr_DataSnap_LOG
   echo ""                                                                                                         >> $Incr_DataSnap_LOG
          su - $ORACLE_USER -c "${SHELLDIR}/run_del_Daily_datasnap.sh  	$DB_DIR               			"  >> $Incr_DataSnap_LOG
   echo "-------------------------------------------------------------------------------------------------------"  

          RSTAT=$?
 else
   echo "-------------------------------------------------------------------------------------------------------"  >> $Incr_DataSnap_LOG
   echo " *** Create Backup Data Snapshot ***                                           [`date '+%F %H:%M:%S'`] "  >> $Incr_DataSnap_LOG
   echo " "                                                                                      		   >> $Incr_DataSnap_LOG
          ${SHELL} -c "${SHELLDIR}/run_Daily_datasnap.sh      		$DB_DIR                            	"  >> $Incr_DataSnap_LOG

   echo "-------------------------------------------------------------------------------------------------------"  >> $Incr_DataSnap_LOG
   echo " *** Delete Expired Backup Data Snapshot ***                                   [`date '+%F %H:%M:%S'`] "  >> $Incr_DataSnap_LOG
   echo ""                                                                                                         >> $Incr_DataSnap_LOG
          ${SHELL} -c "${SHELLDIR}/run_del_Daily_datasnap.sh  		$DB_DIR 				"  >> $Incr_DataSnap_LOG

   echo "-------------------------------------------------------------------------------------------------------"  

          RSTAT=$?
 fi

if [ "$RSTAT" = "0" ]
 then
   echo "-------------------------------------------------------------------------------------------------------"  >> $Incr_DataSnap_LOG

 else
   echo " *** Error(s) occured during snapshot management ***                           [ CODE: $RSTAT ]        "  >> $Incr_DataSnap_LOG
   echo "-------------------------------------------------------------------------------------------------------"  >> $Incr_DataSnap_LOG
 fi

 exit $RSTAT


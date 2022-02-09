#!/bin/bash
DB_DIR=$1
. /ZFS/SCRIPTS/Database/${DB_DIR}/ZFS_Profile

if [ "$RUN_USER" = "root" ]
 then
   echo "-------------------------------------------------------------------------------------------------------" >> $ArchSnap_LOG
   echo " *** Create Archive Log backup snapshot ***                                    [`date '+%F %H:%M:%S'`] " >> $ArchSnap_LOG
   echo ""													  >> $ArchSnap_LOG
          su - $ORACLE_USER -c "${SHELLDIR}/run_Daily_archsnap.sh  	$ARCH_DIR "         		  	  >> $ArchSnap_LOG

   echo "-------------------------------------------------------------------------------------------------------" >> $ArchSnap_LOG
   echo " *** Delete Expired Backup Archive Snapshots ***                               [`date '+%F %H:%M:%S'`] " >> $ArchSnap_LOG
   echo ""													  >> $ArchSnap_LOG
          su - $ORACLE_USER -c "${SHELLDIR}/run_del_Daily_archsnap.sh	$ARCH_DIR "              		  >> $ArchSnap_LOG
   echo "-------------------------------------------------------------------------------------------------------" >> $ArchSnap_LOG

          RSTAT=$?
 else
   echo "-------------------------------------------------------------------------------------------------------" >> $ArchSnap_LOG
   echo " *** Create Archive Log backup snapshot ***                                    [`date '+%F %H:%M:%S'`] " >> $ArchSnap_LOG
   echo ""													  >> $ArchSnap_LOG
          /bin/sh -c "${SHELLDIR}/run_Daily_archsnap.sh         	$ARCH_DIR "		 		  >> $ArchSnap_LOG
 
   echo "-------------------------------------------------------------------------------------------------------" >> $ArchSnap_LOG
   echo " *** Delete Expired Backup Archive Snapshots ***                               [`date '+%F %H:%M:%S'`] " >> $ArchSnap_LOG
   echo ""													  >> $ArchSnap_LOG
          /bin/sh -c "${SHELLDIR}/run_del_Daily_archsnap.sh   	        $ARCH_DIR "            	 		  >> $ArchSnap_LOG
   echo "-------------------------------------------------------------------------------------------------------" >> $ArchSnap_LOG

          RSTAT=$?
 fi

if [ "$RSTAT" = "0" ]
  then
   echo "======================================================================================================="   
 else

   echo " *** Error(s) occured during snapshot management ***                           [ CODE: $RSTAT ]        " >> $ArchSnap_LOG
   echo "======================================================================================================="   
 fi

 exit $RSTAT


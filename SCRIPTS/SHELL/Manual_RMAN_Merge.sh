#!/bin/sh

if [ "$RUN_USER" = "root" ]
 then

        echo "------------------------------------------------------------------------------------------------------- " >> $SHELL_LOG
        echo " *** Starting RMAN Merge Manual Backup                                         [`date '+%F %H:%M:%S'`]  " >> $SHELL_LOG

        su - $ORACLE_USER -c "${RMANDIR}/${DB_DIR}_rman_merge.sh	$DB_DIR $cat_user $cat_pass $cat_db"
#        su - $ORACLE_USER -c "${SHELLDIR}/run_Daily_datasnap.sh      	$DB_DIR " 
 else

        echo "------------------------------------------------------------------------------------------------------- " >> $SHELL_LOG
        echo " *** Starting RMAN Merge Manual Backup                                         [`date '+%F %H:%M:%S'`]  " >> $SHELL_LOG

        ${SHELL} -c "${RMANDIR}/${DB_DIR}_rman_merge.sh   		$DB_DIR $cat_user $cat_pass $cat_db"
#        ${SHELL} -c "${SHELLDIR}/run_Daily_datasnap.sh      		$DB_DIR " 

        RSTAT=$?
 fi
        echo " ----------------------------------------------------------------------------------------------------- " 

if [ "$RSTAT" = "0" ]
 then
        echo "======================================================================================================= " >> $SHELL_LOG

 else
        echo " *** Error occured during RMAN Merge Manual Backup     	                 [ CODE : $RSTAT ]            " >> $SHELL_LOG
        echo "======================================================================================================= " >> $SHELL_LOG
  fi
 exit $RSTAT


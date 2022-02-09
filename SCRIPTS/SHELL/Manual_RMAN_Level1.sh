#!/bin/sh

if [ "$RUN_USER" = "root" ]
 then
        echo "======================================================================================================= " >> $SHELL_LOG
        echo " *** Starting RMAN Level 1 Manual Backup                                       [`date '+%F %H:%M:%S'`]  " >> $SHELL_LOG

        su - $ORACLE_USER -c "${RMANDIR}/${DB_DIR}_rman_incr_level1.sh  	$DB_DIR $cat_user $cat_pass $cat_db"
 else

        echo "------------------------------------------------------------------------------------------------------- " >> $SHELL_LOG
        echo " *** Starting RMAN Level 1 Manual Backup                                       [`date '+%F %H:%M:%S'`]  " >> $SHELL_LOG

        ${SHELL} -c "${RMANDIR}/${DB_DIR}_rman_incr_level1.sh 		$DB_DIR $cat_user $cat_pass $cat_db"

        RSTAT=$?
 fi
        echo "------------------------------------------------------------------------------------------------------- " >> $SHELL_LOG

if [ "$RSTAT" = "0" ]
 then
        echo " *** RMAN Incremental Level 1 Manual Backup has been finished                  [`date '+%F %H:%M:%S'`]  " >> $SHELL_LOG
        echo "------------------------------------------------------------------------------------------------------- " >> $SHELL_LOG

 else
        echo " *** Error occured during RMAN Incremental Level 1 Backup                  [ CODE : $RSTAT ]            " >> $SHELL_LOG
        echo "------------------------------------------------------------------------------------------------------- " >> $SHELL_LOG
  fi
 exit $RSTAT


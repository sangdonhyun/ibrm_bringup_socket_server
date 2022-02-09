#!/bin/sh

if [ "$RUN_USER" = "root" ]
 then
        echo "======================================================================================================= " >> $SHELL_LOG
        echo " *** Starting RMAN Level 0 Image Manual Backup                                 [`date '+%F %H:%M:%S'`]  " >> $SHELL_LOG 

        su - $ORACLE_USER -c "${RMANDIR}/${DB_DIR}_rman_incr_level0.sh 	$DB_DIR $cat_user $cat_pass $cat_db"
#        su - $ORACLE_USER -c "${SHELLDIR}/run_Daily_datasnap.sh      	$DB_DIR "

        RSTAT=$?
 else

        echo "======================================================================================================= " >> $SHELL_LOG
        echo " *** Starting RMAN Level 0 Image Manual Backup                                 [`date '+%F %H:%M:%S'`]  " >> $SHELL_LOG 

        ${SHELL} -c "${RMANDIR}/${DB_DIR}_rman_incr_level0.sh  		$DB_DIR $cat_user $cat_pass $cat_db" 
#        ${SHELL} -c "${SHELLDIR}/run_Daily_datasnap.sh      		$DB_DIR "

        RSTAT=$?
 fi

	echo " ----------------------------------------------------------------------------------------------------- " >> $SHELL_LOG

if [ "$RSTAT" = "0" ]
 then
        echo " *** RMAN Level 0 Manual Backup has been finished                              [`date '+%F %H:%M:%S'`]  " >> $SHELL_LOG 
        echo "======================================================================================================= " >> $SHELL_LOG

 else

        echo " *** Error occured during RMAN Level 0 Manual Backup                           [ CODE: $RSTAT ]         " >> $SHELL_LOG
        echo "======================================================================================================= " >> $SHELL_LOG
 fi
 exit $RSTAT

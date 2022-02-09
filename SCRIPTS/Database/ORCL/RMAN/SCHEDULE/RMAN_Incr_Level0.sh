#!/bin/sh
DB_DIR=$1
. /ZFS/SCRIPTS/Database/${DB_DIR}/ZFS_Profile

if [ "$RUN_USER" = "root" ]
 then
       echo " " 												       >> $SHELL_LOG
       echo "======================================================================================================="  >> $SHELL_LOG
       echo " *** Start RMAN Incremental Level 0 Backup ***                                 [`date '+%F %H:%M:%S'`] "  >> $SHELL_LOG
        su - $ORACLE_USER -c "${RMANDIR}/${DB_DIR}_rman_incr_level0.sh     	$DB_DIR $cat_user $cat_pass $cat_db"
        su - $ORACLE_USER -c "${RMANDIR}/${DB_DIR}_rman_incr_snap.sh        	$DB_DIR"
        su - $ORACLE_USER -c "${RMANDIR}/${DB_DIR}_archivelog.sh             	$DB_DIR $cat_user $cat_pass $cat_db"
        su - $ORACLE_USER -c "${RMANDIR}/${DB_DIR}_archivelog_snap.sh        	$DB_DIR"
        su - $ORACLE_USER -c "${SHELLDIR}/run_del_backuplog.sh               	$DB_DIR"


        RSTAT=$?
 else
	echo " "												       >> $SHELL_LOG
       	echo "=======================================================================================================" >> $SHELL_LOG
        echo " *** Start RMAN Incremental Level 0 Backup ***                                 [`date '+%F %H:%M:%S'`] " >> $SHELL_LOG

        ${SHELL} -c "${RMANDIR}/${DB_DIR}_rman_incr_level0.sh           	$DB_DIR $cat_user $cat_pass $cat_db"
        ${SHELL} -c "${RMANDIR}/${DB_DIR}_rman_incr_snap.sh          	$DB_DIR"
        ${SHELL} -c "${RMANDIR}/${DB_DIR}_archivelog.sh                 	$DB_DIR $cat_user $cat_pass $cat_db"
        ${SHELL} -c "${RMANDIR}/${DB_DIR}_archivelog_snap.sh            	$DB_DIR"
        ${SHELL} -c "${SHELLDIR}/run_del_backuplog.sh                   	$DB_DIR"


        RSTAT=$?
 fi

if [ "$RSTAT" = "0" ]
 then
       echo " *** RMAN Incremental Level 0 Image Backup has been finished ***               [`date '+%F %H:%M:%S'`] " >> $SHELL_LOG 
       echo "=======================================================================================================" >> $SHELL_LOG
 else
       echo " *** Error(s) occured during RMAN Incremental Level 0 Backup ***               [ CODE: $RSTAT ]  	    " >> $SHELL_LOG
       echo "=======================================================================================================" >> $SHELL_LOG
 fi

 exit $RSTAT
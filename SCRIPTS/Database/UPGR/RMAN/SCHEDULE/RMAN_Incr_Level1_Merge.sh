#!/bin/bash
DB_DIR=$1
. /ZFS/SCRIPTS/Database/${DB_DIR}/ZFS_Profile

if [ "$RUN_USER" = "root" ]
then
       echo " "                                                                                                       >> $SHELL_LOG
       echo "=======================================================================================================" >> $SHELL_LOG
       echo " *** Start Daily RMAN Incremental Level 1 Backup ***                           [`date '+%F %H:%M:%S'`] " >> $SHELL_LOG

       su - $ORACLE_USER -c "${RMANDIR}/${DB_DIR}_rman_incr_level1.sh      	$DB_DIR $cat_user $cat_pass $cat_db"
       su - $ORACLE_USER -c "${RMANDIR}/${DB_DIR}_rman_merge.sh                 $DB_DIR $cat_user $cat_pass $cat_db"
       su - $ORACLE_USER -c "${RMANDIR}/${DB_DIR}_rman_incr_snap.sh      	$DB_DIR"
       su - $ORACLE_USER -c "${RMANDIR}/${DB_DIR}_archivelog.sh                 $DB_DIR $cat_user $cat_pass $cat_db"
       su - $ORACLE_USER -c "${RMANDIR}/${DB_DIR}_archivelog_snap.sh            $DB_DIR"
       su - $ORACLE_USER -c "${SHELLDIR}/run_del_backuplog.sh                   $DB_DIR"




        RSTAT=$?
 else
       echo " "                                                                                         	      >> $SHELL_LOG
       echo "=======================================================================================================" >> $SHELL_LOG
       echo " *** Start Daily RMAN Incremental Level 1 Backkup ***                          [`date '+%F %H:%M:%S'`] " >> $SHELL_LOG

       /bin/sh -c "${RMANDIR}/${DB_DIR}_rman_incr_level1.sh		$DB_DIR $cat_user $cat_pass $cat_db "
       /bin/sh -c "${RMANDIR}/${DB_DIR}_rman_merge.sh                 	$DB_DIR $cat_user $cat_pass $cat_db"
       /bin/sh -c "${RMANDIR}/${DB_DIR}_rman_incr_snap.sh      		$DB_DIR"
       /bin/sh -c "${RMANDIR}/${DB_DIR}_archivelog.sh                 	$DB_DIR $cat_user $cat_pass $cat_db"
       /bin/sh -c "${RMANDIR}/${DB_DIR}_archivelog_snap.sh            	$DB_DIR"
       /bin/sh -c "${SHELLDIR}/run_del_backuplog.sh                   	$DB_DIR"

        RSTAT=$?
 fi


 if [ "$RSTAT" = "0" ]
 then  
       echo " *** RMAN Incremental Level1 Backup has been finished ***                      [`date '+%F %H:%M:%S'`] " >> $SHELL_LOG
       echo "=======================================================================================================" >> $SHELL_LOG

 else
       echo " *** Error occured during Incremental Backup ***                               [ CODE: $RSTAT ]        " >> $SHELL_LOG
       echo "=======================================================================================================" >> $SHELL_LOG


 fi
 exit $RSTAT


#!/bin/sh
DB_DIR=$1
. /ZFS/SCRIPTS/Database/${DB_DIR}/ZFS_Profile

if [ "$RUN_USER" = "root" ]
then
       echo " "                                                                                                       >> $SHELL_LOG
       echo "=======================================================================================================" >> $SHELL_LOG
       echo " *** Start Daily RMAN Incremental Level 1 Backup ***                           [`date '+%F %H:%M:%S'`] " >> $SHELL_LOG

       su - $ORACLE_USER -c "${RMANDIR}/${DB_DIR}_rman_incr_level1.sh      $DB_DIR $cat_user $cat_pass $cat_db"
       su - $ORACLE_USER -c "${RMANDIR}/${DB_DIR}_archivelog.sh            $DB_DIR $cat_user $cat_pass $cat_db"



        RSTAT=$?
 else
       echo " "                                                                                         	      >> $SHELL_LOG
       echo "=======================================================================================================" >> $SHELL_LOG
       echo " *** Start Daily RMAN Incremental Level 1 Backkup ***                          [`date '+%F %H:%M:%S'`] " >> $SHELL_LOG

        ${SHELL} -c "${RMANDIR}/${DB_DIR}_rman_incr_level1.sh	$DB_DIR $cat_user $cat_pass $cat_db "
        ${SHELL} -c "${RMANDIR}/${DB_DIR}_archivelog.sh		$DB_DIR $cat_user $cat_pass $cat_db "

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


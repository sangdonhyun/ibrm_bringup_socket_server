#!/bin/sh
DB_DIR=ORCL
. /ZFS/SCRIPTS/Database/${DB_DIR}/ZFS_Profile

if [ "$RUN_USER" = "root" ]
 then
       echo " " 												       >> $SHELL_LOG
       echo "======================================================================================================="  >> $SHELL_LOG
       echo " *** Start RMAN Full Backup ***                                                [`date '+%F %H:%M:%S'`] "  >> $SHELL_LOG

        su - $ORACLE_USER -c "${RMANDIR}/${DB_DIR}_rman_Full.sh             $DB_DIR $cat_user $cat_pass $cat_db"
        su - $ORACLE_USER -c "${RMANDIR}/${DB_DIR}_rman_Full_snap.sh        $DB_DIR"
        su - $ORACLE_USER -c "${RMANDIR}/${DB_DIR}_archivelog.sh            $DB_DIR $cat_user $cat_pass $cat_db"
        su - $ORACLE_USER -c "${RMANDIR}/${DB_DIR}_archivelog_snap.sh       $DB_DIR"


        RSTAT=$?
 else
	echo " "												       >> $SHELL_LOG
       	echo "=======================================================================================================" >> $SHELL_LOG
        echo " *** Start RMAN Full Backup ***                                                [`date '+%F %H:%M:%S'`] " >> $SHELL_LOG

        ${SHELL} -c "${RMANDIR}/${DB_DIR}_rman_Full.sh               	$DB_DIR $cat_user $cat_pass $cat_db"
        ${SHELL} -c "${RMANDIR}/${DB_DIR}_rman_Full_snap.sh          	$DB_DIR"
        ${SHELL} -c "${RMANDIR}/${DB_DIR}_archivelog.sh                  $DB_DIR $cat_user $cat_pass $cat_db"
        ${SHELL} -c "${RMANDIR}/${DB_DIR}_archivelog_snap.sh             $DB_DIR"


        RSTAT=$?
 fi

if [ "$RSTAT" = "0" ]
 then
       echo " *** RMAN Full Backup has been finished ***                                    [`date '+%F %H:%M:%S'`] " >> $SHELL_LOG 
       echo "=======================================================================================================" >> $SHELL_LOG
 else
       echo " *** Error(s) occured during RMAN Full Backup ***                              [ CODE: $RSTAT ]  	    " >> $SHELL_LOG
       echo "=======================================================================================================" >> $SHELL_LOG
 fi

 exit $RSTAT

#!/bin/bash
DB_DIR=$1
. /ZFS/SCRIPTS/Database/${DB_DIR}/ZFS_Profile

if [ "$RUN_USER" = "root" ]
 then
       echo " *** Start RMAN Archive Log Backup ***                                         [`date '+%F %H:%M:%S'`] " >> $SHELL_LOG
        su - $ORACLE_USER -c "${RMANDIR}/${DB_DIR}_archivelog.sh   $DB_DIR $cat_user $cat_pass $cat_db"

        RSTAT=$?

       echo "-------------------------------------------------------------------------------------------------------"
 else
       echo " *** Start RMAN Archive Log Backup ***                                         [`date '+%F %H:%M:%S'`] " >> $SHELL_LOG
        /bin/sh -c "${RMANDIR}/${DB_DIR}_archivelog.sh             $DB_DIR $cat_user $cat_pass $cat_db"

        RSTAT=$?
 fi

       echo "-------------------------------------------------------------------------------------------------------"

if [ "$RSTAT" = "0" ]
 then
       echo "=======================================================================================================" >> $SHELL_LOG 
 else
       echo " *** Error(s) occured during RMAN Archive Log Backup ***                       [ CODE: $RSTAT ]  	    " >> $SHELL_LOG
       echo "=======================================================================================================" >> $SHELL_LOG 
 fi

 exit $RSTAT

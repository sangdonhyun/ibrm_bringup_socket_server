#!/bin/sh

if [ "$RUN_USER" = "root" ]
 then

        echo "------------------------------------------------------------------------------------------------------- " >> $SHELL_LOG
        echo " *** Starting Archive Log Manual Backup                                        [`date '+%F %H:%M:%S'`]  " >> $SHELL_LOG

         su - $ORACLE_USER -c "${RMANDIR}/${DB_DIR}_archivelog.sh 	$DB_DIR  $cat_user $cat_pass $cat_db "
#        su - $ORACLE_USER -c "${SHELLDIR}/run_del_arch_data.sh     	$DB_DIR  "
#        su - $ORACLE_USER -c "${SHELLDIR}/run_Daily_archsnap.sh     	$DB_DIR  "

        RSTAT=$?
 else

        echo "------------------------------------------------------------------------------------------------------- " >> $SHELL_LOG
        echo " *** Starting Archive Log Manual Backup                                        [`date '+%F_%H:%M:%S'`]  " >> $SHELL_LOG

         ${SHELL} -c "${RMANDIR}/${DB_DIR}_archivelog.sh  		$DB_DIR $cat_user $cat_pass $cat_db "
#        ${SHELL} -c "${SHELLDIR}/run_del_arch_data.sh     		$DB_DIR "
#        ${SHELL} -c "${SHELLDIR}/run_Daily_archsnap.sh     		$DB_DIR "

        RSTAT=$?
fi

        echo "------------------------------------------------------------------------------------------------------- " 

if [ "$RSTAT" = "0" ]
 then
        echo "------------------------------------------------------------------------------------------------------- " >> $SHELL_LOG

 else
        echo " *** Error(s) has occured during Archive Log Manual Backup ***                 [ CODE: $RSTAT ]        " >> $SHELL_LOG
        echo "-------------------------------------------------------------------------------------------------------" >> $SHELL_LOG
fi
 exit $RSTAT


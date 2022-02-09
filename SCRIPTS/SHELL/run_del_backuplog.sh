 DB_DIR=$1
. ${BASEDIR}/SCRIPTS/Database/${DB_DIR}/ZFS_Profile

 ls ${LOGDIR}/${DB_DIR}|grep ${DB_NAME} > /tmp/list_bklog.out

grep ${DB_NAME} /tmp/list_bklog.out |awk '$1 < "'${DB_NAME}'_'${Backup_Log}'" ' >  /tmp/del_bklog.out

 while read BACK_LOG
do

        BAKLOG=" rm -r \${LOGDIR}/${DB_DIR}/${BACK_LOG} "  ; echo $BAKLOG | sh
done < /tmp/del_bklog.out


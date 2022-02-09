DB_DIR=$1
. ${BASEDIR}/SCRIPTS/Database/${DB_DIR}/ZFS_Profile

 ls ${BACKUP_ARCH_DIR1}|grep ${DB_NAME} > /tmp/list_${DB_DIR}_arch.out

grep ${DB_NAME} /tmp/list_${DB_DIR}_arch.out |awk '$1 < "'${DB_NAME}'_'${Backup_Archlog}'" ' >  /tmp/del_${DB_DIR}_arch.out

 while read ARCH_DATA
do

i=1
while [ $i -le $ARCH_NO ]
do
        ARCH=" rm -r \${BACKUP_ARCH_DIR${i}}/${ARCH_DATA} "  ; echo $ARCH | sh
        i=$(( $i + 1 ))
done
done < /tmp/del_${DB_DIR}_arch.out


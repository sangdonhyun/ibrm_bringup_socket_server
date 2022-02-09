DB_DIR=$1
. ${BASEDIR}/SCRIPTS/Database/${DB_DIR}/ZFS_Profile

timestamp=`date '+%Y%m%d_%H%M'`

#echo "${BACKUP_ARCH_DIR1}/.zfs/snapshot/Weekly_Arch_$timestamp" >  ${BACKUP_DATA_DIR1}/arch_snapshot_tape.txt
#echo "${BACKUP_ARCH_DIR2}/.zfs/snapshot/Weekly_Arch_$timestamp" >> ${BACKUP_DATA_DIR1}/arch_snapshot_tape.txt

i=1
while [ "$i" -le "$ARCH_NO" ]
do
        ZFS="\${ZFSDIR}/snap.sh \${LOGINSTRING_${i}} \${POOLNAME_${i}} \${ARCH_PROJNAME} \${SHARE_ARCH_${i}} Weekly_Arch_$timestamp " ; echo $ZFS | sh
        i=$(( $i + 1 ))
done

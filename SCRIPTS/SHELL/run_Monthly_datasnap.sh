if [ $# -lt 1 ]
then
        timestamp=`date '+%Y%m%d_%H%M'`
else
        timestamp=$1
fi

#echo "${BACKUP_DATA_DIR1}/.zfs/snapshot/Monthly_Data_$timestamp/DCH1" >  ${BACKUP_DATA_DIR1}/data_snapshot_tape.txt
#echo "${BACKUP_DATA_DIR2}/.zfs/snapshot/Monthly_Data_$timestamp/DCH2" >> ${BACKUP_DATA_DIR1}/data_snapshot_tape.txt
#echo "${BACKUP_DATA_DIR1}/.zfs/snapshot/Monthly_Data_$timestamp/DCH3" >> ${BACKUP_DATA_DIR1}/data_snapshot_tape.txt
#echo "${BACKUP_DATA_DIR2}/.zfs/snapshot/Monthly_Data_$timestamp/DCH4" >> ${BACKUP_DATA_DIR1}/data_snapshot_tape.txt
#echo "${BACKUP_DATA_DIR1}/.zfs/snapshot/Monthly_Data_$timestamp/DCH5" >> ${BACKUP_DATA_DIR1}/data_snapshot_tape.txt
#echo "${BACKUP_DATA_DIR2}/.zfs/snapshot/Monthly_Data_$timestamp/DCH6" >> ${BACKUP_DATA_DIR1}/data_snapshot_tape.txt
#echo "${BACKUP_DATA_DIR1}/.zfs/snapshot/Monthly_Data_$timestamp/DCH7" >> ${BACKUP_DATA_DIR1}/data_snapshot_tape.txt
#echo "${BACKUP_DATA_DIR2}/.zfs/snapshot/Monthly_Data_$timestamp/DCH8" >> ${BACKUP_DATA_DIR1}/data_snapshot_tape.txt

echo "======================================================================================================="  
echo " Start delete previous Incremental Backup Pieces                               [`date '+%F %H:%M:%S'`] " 

rm ${BACKUP_DATA_DIR1}/DCH1/*_1_1 &
rm ${BACKUP_DATA_DIR2}/DCH2/*_1_1 &
rm ${BACKUP_DATA_DIR1}/DCH3/*_1_1 &
rm ${BACKUP_DATA_DIR2}/DCH4/*_1_1 &
rm ${BACKUP_DATA_DIR1}/DCH5/*_1_1 &
rm ${BACKUP_DATA_DIR2}/DCH6/*_1_1 &
rm ${BACKUP_DATA_DIR1}/DCH7/*_1_1 &
rm ${BACKUP_DATA_DIR2}/DCH8/*_1_1 &
wait
echo "-------------------------------------------------------------------------------------------------------"
echo " Delete previous Incremental Backup Pieces has been completed                  [`date '+%F %H:%M:%S'`] "
echo "======================================================================================================="

i=1
while [ $i -le $DSHARE_NO ]
do
        ZFS="\${ZFSDIR}/snap.sh \${LOGINSTRING_${i}} \${POOLNAME_${i}} \${DATA_PROJNAME} \${SHARE_DATA_${i}} Monthly_Data_$timestamp " ; echo $ZFS | sh
        i=$(( $i + 1 ))
done
echo "${BACKUP_DATA_DIR1}/.zfs/snapshot/Monthly_Data_$timestamp" > ${BACKUP_DATA_DIR1}/data_snapshot_tape.txt

echo -n "Input Snap_Data Name for rollback : "
read Rollback_DataSnap

i=1
while [ $i -le $DSHARE_NO ]
do
        ZFS="\${ZFSDIR}/snap_rollback.sh \${LOGINSTRING_${i}} \${POOLNAME_${i}} \${DATA_PROJNAME} \${SHARE_DATA_${i}} $Rollback_DataSnap " ; echo $ZFS | sh
        i=$(( $i + 1 ))
done

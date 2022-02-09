echo -n "Input Snap_Arch Name for rollback : "
read Rollback_ArchSnap

i=1
while [ $i -le $ARCH_NO ]
do
        ZFS="\${ZFSDIR}/snap_rollback.sh \${LOGINSTRING_${i}} \${POOLNAME_${i}} \${ARCH_PROJNAME} \${SHARE_ARCH_${i}} $Rollback_ArchSnap " ; echo $ZFS | sh
        i=$(( $i + 1 ))
done

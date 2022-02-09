echo "***********************************************************************" 
i=1
while [ $i -le $DSHARE_NO ]
do

echo "echo " ZFS RMAN FULL Backup Snapshot List [ POOL: \${POOLNAME_${i}} ] [ PROJECT: \${DATA_PROJNAME} ]""|sh
echo ""
ZFS="\${ZFSDIR}/show_snap.sh \${LOGINSTRING_${i}} \${POOLNAME_${i}} \${DATA_PROJNAME} \${SHARE_DATA_${i}} |grep -v "login:""  ; echo $ZFS | sh
       i=$(( $i + 1 ))

echo ""
echo "***********************************************************************" 
done

echo ""
echo "======================================================================="
j=1
while [ $j -le $ARCH_NO ]
do

echo "echo " ZFS Archive Log Backup Snapshot List [ POOL: \${POOLNAME_${j}} ] [ PROJECT: \${ARCH_PROJNAME} ]""|sh
echo ""
ZFS="\${ZFSDIR}/show_snap.sh \${LOGINSTRING_${j}} \${POOLNAME_${j}} \${ARCH_PROJNAME} \${SHARE_ARCH_${j}} |grep -v "login:""  ; echo $ZFS | sh
       j=$(( $j + 1 ))

echo ""
echo "======================================================================="
done

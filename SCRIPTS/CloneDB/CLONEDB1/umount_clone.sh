i=1
j=1
while [ $i -le $ARCH_NO ]
do
        ZFS="umount \${CLONE_ARCH_DIR${i}} " ; echo ${ZFS} | sh
        i=$(( $i + 1 ))
done

while [ $j -le $DSHARE_NO ]
do
        ZFS="umount  \${CLONE_DATA_DIR${j}} " ; echo ${ZFS} | sh
        j=$(( $j + 1 ))
done

echo "*************************************************************************************************************"
echo "Filesystem                           Type       Size  Used  Avail Use% Mounted on                      "
echo "-------------------------------------------------------------------------------------------------------------"
df -PhT |grep ${CLONEDIR} |sort -k1
echo "*************************************************************************************************************"


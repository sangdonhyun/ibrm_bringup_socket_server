DB_DIR=$1
. ${BASEDIR}/SCRIPTS/Database/${DB_DIR}/ZFS_Profile

sh ${SHELLDIR}/run_show_PRODsnap.sh > /tmp/snaplist.out
grep Full_Data_ /tmp/snaplist.out |sort|uniq | awk '$1 < "Full_Data_'${Full_SnapDate}'"' > /tmp/del_full_datalist.out

while read SNAP_DATA
do

i=1
while [ $i -le $DSHARE_NO ]
do
        ZFS="\${ZFSDIR}/del_snap.sh \${LOGINSTRING_${i}} \${POOLNAME_${i}} \${DATA_PROJNAME} $SNAP_DATA \${SHARE_DATA_${i}} " ; echo $ZFS | sh
        i=$(( $i + 1 ))
done

done < /tmp/del_full_datalist.out

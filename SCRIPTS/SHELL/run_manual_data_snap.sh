if [ $# -lt 2 ]
then
        timestamp=`date '+%Y%m%d_%H%M'`
else
        timestamp=$1

fi

i=1
while [ $i -le $DSHARE_NO ]
do
        ZFS="\${ZFSDIR}/snap.sh \${LOGINSTRING_${i}} \${POOLNAME_${i}} \${DATA_PROJNAME} \${SHARE_DATA_${i}} Daily_Data_$timestamp " ; echo $ZFS | sh
        i=$(( $i + 1 ))
done

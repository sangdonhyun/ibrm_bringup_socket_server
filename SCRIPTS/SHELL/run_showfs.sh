i=1
while [ $i -le $DSHARE_NO ]
do

echo "======================================================================="
echo "echo " List of Shared File systmes [ POOL: \${POOLNAME_${i}} ] [ PROJECT: \${DATA_PROJNAME} ]"" |sh
ZFS="\${ZFSDIR}/show_shared_fs.sh \${LOGINSTRING_${i}} \${POOLNAME_${i}} \${DATA_PROJNAME} |grep -v "login:""  ; echo ${ZFS} |sh
echo "" 											
       i=$(( $i + 1 ))
done
echo "======================================================================="

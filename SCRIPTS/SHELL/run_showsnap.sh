echo "======================================================================="
echo "RMAN FULL Backup Snapshot List [ PROJECT:${DATA_PROJNAME} ] "
${ZFSDIR}/show_snap.sh ${LOGINSTRING_1} ${POOLNAME_1} ${DATA_PROJNAME} ${SHARE_DATA_1} |grep -v "login:"
echo ""
echo "********************************************************************"
echo "Archive Log Backup Snapshot List [ PROJECT:${ARCH_PROJNAME} ]"
${ZFSDIR}/show_snap.sh ${LOGINSTRING_1} ${POOLNAME_1} ${ARCH_PROJNAME} ${SHARE_ARCH_1} |grep -v "login:"
echo ""
echo "======================================================================="


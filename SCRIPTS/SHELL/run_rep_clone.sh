echo "=========================================================================="
echo "Create Clone from replicated Project [ PROJECT: ${REP_PROJNAME} ]"
${ZFSDIR}/clone_replica.sh ${LOGINSTRING_1} ${SOURCENAME_1} ${PKGNAME_1} ${REP_PROJNAME} |grep -v " login:" 	
echo "=========================================================================="		
#echo "=========================================================================="
#echo "Create Clone from replicated Project [ PROJECT: ${REP_PROJNAME} ]"
#${ZFSDIR}/clone_replica.sh ${LOGINSTRING_2} ${SOURCENAME_2} ${PKGNAME_2} ${REP_PROJNAME} |grep -v " login:" 	
#echo "=========================================================================="		

echo "STARTUP NOMOUNT " 							> ${DBADIR}/create_control.tmp
echo "CREATE CONTROLFILE SET DATABASE $ORACLE_SID  RESETLOGS  ARCHIVELOG "      >> ${DBADIR}/create_control.tmp
echo "    MAXLOGFILES 16 "                                                      >> ${DBADIR}/create_control.tmp
echo "    MAXLOGMEMBERS 3 "                                                     >> ${DBADIR}/create_control.tmp
echo "    MAXDATAFILES 1500 "                                                   >> ${DBADIR}/create_control.tmp
echo "    MAXINSTANCES 8 "                                                      >> ${DBADIR}/create_control.tmp
echo "    MAXLOGHISTORY 500 "                                                   >> ${DBADIR}/create_control.tmp
echo "LOGFILE "                                                                 >> ${DBADIR}/create_control.tmp
echo "  GROUP 1 ('${CLONE_DATA_DIR1}/redolog01.log') SIZE 100M BLOCKSIZE 512, " >> ${DBADIR}/create_control.tmp
echo "  GROUP 2 ('${CLONE_DATA_DIR2}/redolog02.log') SIZE 100M BLOCKSIZE 512, " >> ${DBADIR}/create_control.tmp
echo "  GROUP 3 ('${CLONE_DATA_DIR1}/redolog03.log') SIZE 100M BLOCKSIZE 512, " >> ${DBADIR}/create_control.tmp
echo "  GROUP 4 ('${CLONE_DATA_DIR2}/redolog04.log') SIZE 100M BLOCKSIZE 512  " >> ${DBADIR}/create_control.tmp
echo "DATAFILE"                                                                 >> ${DBADIR}/create_control.tmp

no=1
for i in `cat ${DBADIR}/list_clonedata.out`
do
echo " '$i', "								        >> ${DBADIR}/create_control.tmp
let no=no+1
done
sed '$s/',/'; /g' ${DBADIR}/create_control.tmp			 		> ${DBADIR}/create_control.sql 

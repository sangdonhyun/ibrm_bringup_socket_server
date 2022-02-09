#!/bin/sh

if [ ! -d ${CLONEDB_LOG} ]
then
mkdir -p ${CLONEDB_LOG}
fi
touch ${CLONEDB_Recover_LOG}

echo "sed '1,\$s/BACKUP/${CLONEDIR}/g'  \${CLONE_DATA_DIR1}/list_data.out | \
      sed '1,\$s/${CLONEDIR}/${CLONE_DATA_1}/g'| \
      sed '1,\$s/${BACKUP_DATA_2}/${CLONE_DATA_2}/g' " | \
      sh  > ${DBADIR}/list_clonedata.out

ls ${DBADIR}/list_clonedata.out
echo `cat ${DBADIR}/list_clonedata.out`
if [ -f ${DBADIR}/create_control.sql ]
then
rm -f ${DBADIR}/create_control.sql
rm -f ${CLONE_DATA_DIR1}/new_control01.ctl
fi

${SHELL} ${DBADIR}/run_crcontrol.sh

echo "********************************************************************************************************************"
echo "Copy init file from ${DBADIR}/init${ORACLE_SID}.ora to ${ORACLE_HOME}/dbs/ "

cp -rp ${DBADIR}/init${ORACLE_SID}.ora ${ORACLE_HOME}/dbs/init${ORACLE_SID}.ora

echo "********************************************************************************************************************"
echo ""
echo "********************************************************************************************************************"
echo "Create control file for CLONEDB "
echo "--------------------------------------------------------------------------------------------------------------------"

sqlplus -s / as sysdba << EOF
shutdown abort
@$DBADIR/create_control.sql
EOF
cp ${CLONE_ARCH_DIR1}/1.Backup_summary.log      ${LOGDIR}/Backup_summary.log
echo "**[ End of Step 1 ]*************************************************************************************************"

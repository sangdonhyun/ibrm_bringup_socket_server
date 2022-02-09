sqlplus -s / as sysdba << EOF > Daily_backup_result
@/${SQLDIR}/Daily_Backup_result_log.sql
EOF
cat Daily_backup_result

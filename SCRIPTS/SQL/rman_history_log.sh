sqlplus -s / as sysdba << EOF >  ${BACKUP_ARCH_DIR1}/4.Disk_usage.log
@/${SQLDIR}/rman_history_log.sql
EOF

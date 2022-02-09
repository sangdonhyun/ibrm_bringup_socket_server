DB_DIR=$1
. ${BASEDIR}/SCRIPTS/Database/${DB_DIR}/ZFS_Profile
sqlplus -s / as sysdba << EOF > /tmp/cancel_rman_process
select 'Alter system kill session '''||b.sid||','||b.serial#||''' immediate;'
from v\$process a, v\$session b
where a.addr=b.paddr and client_info like 'rman%';
EOF
sed '1,2d' /tmp/cancel_rman_process > ${SQLDIR}/cancel_rman_backup.sql
sqlplus -s / as sysdba << EOF
@/${SQLDIR}/cancel_rman_backup.sql
EOF

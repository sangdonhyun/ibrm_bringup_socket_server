#!/bin/sh
DB_DIR=$1
. ${BASEDIR}/SCRIPTS/Database/${DB_DIR}/ZFS_Profile

sqlplus -s / as sysdba << EOF
set feedback off
col sid for 99999
col serial# for 9999999
col spid for a8
col client_info for a30
select b.sid, b.serial#, a.spid, b.client_info
from v\$process a, v\$session b
where a.addr=b.paddr and client_info like 'rman%';
EOF

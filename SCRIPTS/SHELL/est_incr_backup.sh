sqlplus -s / as sysdba << EOF
@/${SQLDIR}/ct_blocks_changed_summary.sql
EOF


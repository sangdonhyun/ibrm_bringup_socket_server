import os
import sys



class bring_up():
    def __init__(self):
        self.oracle_sid= 'CLONEDB1'
        self.oracle_home = '/u01/app/oracle/product/18c'
        self.owner = "oracle"
        self.evn = os.environ



    def recover_time(self,arch_date,arch_time):
        """
        DATE=$1
TIME=$2
echo " Start Time based Recovery !! : `date '+%F_%H:%M:%S'`" >> $CLONEDB_Recover_LOG
rman target /  << EOF >> $CLONEDB_Recover_LOGrun {
   ALLOCATE CHANNEL CH01 TYPE DISK;
   ALLOCATE CHANNEL CH02 TYPE DISK;
   ALLOCATE CHANNEL CH03 TYPE DISK;
   ALLOCATE CHANNEL CH04 TYPE DISK;

     set until time "to_date('${DATE} ${TIME}', 'yyyy/mm/dd HH24:MI:SS')";
     recover database;
}
exit;
EOF

echo ""                                                                                                                         >> ${CLONEDB_Recover_LOG}
echo "**[ Please wait until creating redo log files to open CLONE DB ]****************************************************"     >> ${CLONEDB_Recover_LOG}
echo "**[ Check the status of the CLONE DB after the recovery is complete. ]**********************************************"     >> ${CLONEDB_Recover_LOG}
echo ""                                                                                                                         >> ${CLONEDB_Recover_LOG}

sqlplus -s / as sysdba << EOF >> $CLONEDB_Recover_LOG

ALTER DATABASE OPEN RESETLOGS;
ALTER TABLESPACE TEMP ADD TEMPFILE '${CLONE_TEMP}' SIZE 20971520  REUSE AUTOEXTEND ON NEXT 655360  MAXSIZE 32767M;
select instance_name, status from v\$instance;
EOF

echo "Time based Recovery has been Finished : `date '+%F_%H:%M:%S'`" >> $CLONEDB_Recover_LOG
echo ""                                                                                                                         >> ${CLONEDB_Recover_LOG}
echo "**[ End of Step 4 ]*************************************************************************************************"     >> ${CLONEDB_Recover_LOG}

        :return:
        """
        # arch_date = '2021/12/21'
        # arch_time = '13:00:00'
        archive_rman_cmd ="""rman target /  << EOF 
run {
   ALLOCATE CHANNEL CH01 TYPE DISK;
   ALLOCATE CHANNEL CH02 TYPE DISK;
   ALLOCATE CHANNEL CH03 TYPE DISK;
   ALLOCATE CHANNEL CH04 TYPE DISK;

     set until time "to_date('%s %s', 'yyyy/mm/dd HH24:MI:SS')";
     recover database;
}
exit;
EOF
        """%(arch_date,arch_time)
        arch_rman ='/tmp/arch_rman.sql'
        with open(arch_rman,'w') as fw:
            fw.write(archive_rman_cmd)
        cmd = 'su - oracle -c "export ORACLE_SID=CLONEDB1;sh {}"'.format(arch_rman)
        print(cmd)
        print(os.popen(cmd).read())

        arch_rman_check = '/tmp/arch_rman_check.sql'
        check_sql = """
ALTER DATABASE OPEN RESETLOGS;
ALTER TABLESPACE TEMP ADD TEMPFILE '/ZFS/CLONEDB1/DATA_ORCL_11/clone_temp01.tmp' SIZE 20971520  REUSE AUTOEXTEND ON NEXT 655360  MAXSIZE 32767M;
select instance_name, status from v$instance;"""
        with open(arch_rman_check,'w') as fw:
            fw.write(check_sql)
        cmd = """su - oracle -c "export ORACLE_SID=CLONEDB1;sqlplus '/as sysdba' < /tmp/" 
        """.format(arch_rman_check)
        print(cmd)
        print(os.popen(cmd).read())

    def main(self,arch_date,arch_time):
        #4 RecoverTIME

        # arch_date = '2021/12/21'
        # arch_time = '15:40:00'
        self.recover_time(arch_date,arch_time)
if __name__=='__main__':
    arg = sys.argv
    arch_date = arg[1]
    arch_time = arg[2]
    bring_up().main(arch_date,arch_time)
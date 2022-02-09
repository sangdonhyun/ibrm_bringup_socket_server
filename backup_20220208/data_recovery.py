import os


class bring_up():
    def __init__(self):
        self.oracle_sid = 'CLONEDB1'
        self.oracle_home = '/u01/app/oracle/product/18c'
        self.owner = "oracle"
        self.evn = os.environ

    def copy_init_ora(self):
        init_str = """*.audit_trail='none'
*.compatible='18.0.0'
*.control_files='/ZFS/CLONEDB1/DATA_ORCL_11/new_control01.ctl'
*.db_block_size=8192
*.db_domain=''
*.db_name='CLONEDB1'
*.db_recovery_file_dest='/ZFS/CLONEDB1/ARCH_ORCL_11'
*.db_recovery_file_dest_size=1024m
*.open_cursors=300
*.pga_aggregate_target=500m
*.processes=150
*.sga_target=512m
*.undo_tablespace='UNDOTBS1'
*.db_files=2048
log_archive_dest_1='location=/ZFS/CLONEDB1/ARCH_ORCL_11'
log_archive_format='arch_%s_%t_%r.arc'
log_buffer=104857600
nls_date_format='YYYY/MM/DD HH24:MI:SS'
nls_language='AMERICAN'
nls_territory='AMERICA'
"""
        init_file = os.path.join(self.oracle_home, 'dbs', 'init{}.ora'.format(self.oracle_sid))
        with open(init_file, 'w') as fw:
            fw.write(init_str)
        os.popen('chown oracle:dba {}'.format(init_file)).read()
        print('ORACLE INIT FIE :', init_file)
        print(os.popen('cat {}'.format(init_file)).read())

    def make_control_file(self):
        self.copy_init_ora()
        """
        STARTUP NOMOUNT
CREATE CONTROLFILE SET DATABASE CLONEDB1  RESETLOGS  ARCHIVELOG
    MAXLOGFILES 16
    MAXLOGMEMBERS 3
    MAXDATAFILES 1500
    MAXINSTANCES 8
    MAXLOGHISTORY 500
LOGFILE
  GROUP 1 ('/ZFS/CLONEDB1/DATA_ORCL_11/redolog01.log') SIZE 100M BLOCKSIZE 512,
  GROUP 2 ('/ZFS/CLONEDB1/DATA_ORCL_12/redolog02.log') SIZE 100M BLOCKSIZE 512,
  GROUP 3 ('/ZFS/CLONEDB1/DATA_ORCL_11/redolog03.log') SIZE 100M BLOCKSIZE 512,
  GROUP 4 ('/ZFS/CLONEDB1/DATA_ORCL_12/redolog04.log') SIZE 100M BLOCKSIZE 512
DATAFILE
 '/ZFS/CLONEDB1/DATA_ORCL_11/DCH3/data_D-ORCL_I-1594115525_TS-SYSTEM_FNO-1_sl0gsklc',
 '/ZFS/CLONEDB1/DATA_ORCL_11/DCH1/data_D-ORCL_I-1594115525_TS-SYSAUX_FNO-3_sj0gsklb',
 '/ZFS/CLONEDB1/DATA_ORCL_12/DCH2/data_D-ORCL_I-1594115525_TS-UNDOTBS1_FNO-4_sk0gsklb',
 '/ZFS/CLONEDB1/DATA_ORCL_12/DCH4/data_D-ORCL_I-1594115525_TS-FLETA_FNO-5_sm0gsklc',
 '/ZFS/CLONEDB1/DATA_ORCL_12/DCH4/data_D-ORCL_I-1594115525_TS-USERS_FNO-7_sn0gsksd';
        """
        list_file = '/ZFS/CLONEDB1/DATA_ORCL_11/list_data.out'
        # list_file = 'list_data.out'

        with open(list_file) as f:
            line_set = f.readlines()
        clone_data_dir1 = '/ZFS/CLONEDB1/DATA_ORCL_11'
        clone_data_dir2 = '/ZFS/CLONEDB1/DATA_ORCL_12'
        ctr_str = """
SHUTDOWN ABORT;
STARTUP NOMOUNT
CREATE CONTROLFILE SET DATABASE {ORACLE_SID}  RESETLOGS  ARCHIVELOG 
MAXLOGFILES 16 
MAXLOGMEMBERS 3 
MAXDATAFILES 15000 
MAXINSTANCES 8 
MAXLOGHISTORY 500 
LOGFILE 
  GROUP 1 ('{CLONE_DATA_DIR1}/redolog01.log') SIZE 100M BLOCKSIZE 512, 
  GROUP 2 ('{CLONE_DATA_DIR2}/redolog02.log') SIZE 100M BLOCKSIZE 512, 
  GROUP 3 ('{CLONE_DATA_DIR1}/redolog03.log') SIZE 100M BLOCKSIZE 512 ,
  GROUP 4 ('{CLONE_DATA_DIR2}/redolog04.log') SIZE 100M BLOCKSIZE 512   
DATAFILE
""".format(CLONE_DATA_DIR1=clone_data_dir1, CLONE_DATA_DIR2=clone_data_dir2, ORACLE_SID=self.oracle_sid)

        for i in range(len(line_set)):
            line = line_set[i]
            line = line.replace('/ZFS/BACKUP/DATA_ORCL_01/', '/ZFS/CLONEDB1/DATA_ORCL_11/')
            line = line.replace('/ZFS/BACKUP/DATA_ORCL_02/', '/ZFS/CLONEDB1/DATA_ORCL_12/')
            if not i + 1 == len(line_set):
                ctr_str = ctr_str + "   '{}',\n".format(line.strip())
            else:
                ctr_str = ctr_str + "   '{}'; \n".format(line.strip())

        print(ctr_str)
        query_file = '/tmp/create_control.sql'
        with open(query_file, 'w') as f:
            f.write(ctr_str)
        new_control_file = '/ZFS/CLONEDB1/DATA_ORCL_11/new_control01.ctl'
        if os.path.isfile(new_control_file):
            os.remove(new_control_file)

        cmd = """su - {OWNER} -c "export ORACLE_SID={SID};sqlplus  \'/as sysdba\' < {QUERY_FILE}" """.format(
            OWNER=self.owner, SID=self.oracle_sid, QUERY_FILE=query_file)
        print('CMD', cmd)
        ret = os.popen(cmd).read()
        print(ret)

    def backup_catalog(self):
        """
rman target / nocatalog  << EOF >> ${CLONEDB_Recover_LOG}
catalog start with '/ZFS/CLONEDB1/DATA_ORCL_11' noprompt;
catalog start with '/ZFS/CLONEDB1/DATA_ORCL_12' noprompt;
catalog start with '/ZFS/CLONEDB1/ARCH_ORCL_11' noprompt;
catalog start with '/ZFS/CLONEDB1/ARCH_ORCL_12' noprompt;

EOF

cp ${CLONE_ARCH_DIR1}/1.Datafile_history.log ${CLONEDB_LOG}/1.Datafile_history.log
cp ${CLONE_ARCH_DIR1}/2.Archive_history.log  ${CLONEDB_LOG}/2.Archive_history.log
cp ${CLONE_ARCH_DIR1}/3.SCN_number.txt  ${CLONEDB_LOG}/3.SCN_number.txt
"""
        rman_catalog_str = """
catalog start with '/ZFS/CLONEDB1/DATA_ORCL_11' noprompt;
catalog start with '/ZFS/CLONEDB1/DATA_ORCL_12' noprompt;
catalog start with '/ZFS/CLONEDB1/ARCH_ORCL_11' noprompt;
catalog start with '/ZFS/CLONEDB1/ARCH_ORCL_12' noprompt;
        """
        catalog_sql = '/tmp/catalog_start.sql'
        with open(catalog_sql, 'w') as fw:
            fw.write(rman_catalog_str)
        cmd = """su - {OWNER} -c "export ORACLE_SID={SID};rman target / nocatalog < {QUEYR_FILE}" """.format(
            OWNER=self.owner, SID=self.oracle_sid, QUEYR_FILE=catalog_sql)
        ret = os.popen(cmd).read()
        print(ret)
        os.popen('cp /ZFS/CLONEDB1/ARCH_ORCL_11/*.log /ZFS/LOGS/CLONEDB1/').read()
        os.popen('cp /ZFS/CLONEDB1/ARCH_ORCL_11/*.txt /ZFS/LOGS/CLONEDB1/').read()

    def trace_control_file(self):
        trace_file = '/tmp/trace_control.sql'
        if os.path.isfile(trace_file):
            os.remove(trace_file)
        sql = """
alter database backup controlfile to trace as '/tmp/trace_control.sql';
"""
        with open('/tmp/ibrm_trace.sql', 'w') as fw:
            fw.write(sql)
        cmd = """su - oracle -c "export ORACLE_SID=CLONEDB1;sqlplus '/as sysdba' </tmp/ibrm_trace.sql" """
        print(cmd)
        print(os.popen(cmd).read())
        sql_select = """

set lines 160
col "TS#" for 999
col tbs_name for a20
col file_name for a90
col file_size for a11

select t.TS#, t.name tbs_name, f.name file_name, round(f.bytes / 1024 / 1024 ) || ' MB' "FILE_SIZE",f.status, f.checkpoint_change# checkpoint#
from v$datafile f, v$tablespace t where f.TS#=t.TS#
order by t.TS#;

        """
        with open('/tmp/ibrm_trace_select.sql', 'w') as fw:
            fw.write(sql_select)
        cmd = """su - oracle -c "export ORACLE_SID=CLONEDB1;sqlplus '/as sysdba' </tmp/ibrm_trace_select.sql" """
        print(cmd)
        print(os.popen(cmd).read())

    def main(self):
        # 1 create control file
        # 2 Backup Catalog
        # 3 trace_control file
        # 4 RecoverTIME
        self.make_control_file()
        self.backup_catalog()
        self.trace_control_file()


if __name__ == '__main__':
    bring_up().main()

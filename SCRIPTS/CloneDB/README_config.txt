1. Add ZFS file systems mount parameters to /etc/fstab or /etc/vfstab

   - NFS Mount Option for CLONE DBs  

[ Linux : /etc/fstab ]

----- Directory for CLONE DB --------------------------------------------------------------------------------------------------------------------------------------

#----- NFS File systems for SAMPLE Backup -------------------------------------------------------------------------------------------------------------------------
  ZFS_Ctrl1:/export/BAK_dbname_01              /ZFS/BACKUP/DATA_dbname_01                nfs     rw,hard,rsize=1048576,wsize=1048576,tcp,nfsvers=4,timeo=600 0 0
  ZFS_Ctrl2:/export/BAK_dbname_02              /ZFS/BACKUP/DATA_dbname_02                nfs     rw,hard,rsize=1048576,wsize=1048576,tcp,nfsvers=4,timeo=600 0 0
  ZFS_Ctrl1:/export/ARC_dbname_01              /ZFS/BACKUP/ARCH_dbname_01                nfs     rw,hard,rsize=1048576,wsize=1048576,tcp,nfsvers=4,timeo=600 0 0
  ZFS_Ctrl2:/export/ARC_dbname_02              /ZFS/BACKUP/ARCH_dbname_02                nfs     rw,hard,rsize=1048576,wsize=1048576,tcp,nfsvers=4,timeo=600 0 0

## NFS File systems for CloneDB_1
  ZFS_Ctrl1:/export/CLONE_BAK_dbname_11        /ZFS/CLONEDB1/CLONE_DATA_dbname_11        nfs     rw,hard,rsize=32768,wsize=32768,tcp,nfsvers=4,timeo=600 0 0
  ZFS_Ctrl2:/export/CLONE_BAK_dbname_12        /ZFS/CLONEDB1/CLONE_DATA_dbname_12        nfs     rw,hard,rsize=32768,wsize=32768,tcp,nfsvers=4,timeo=600 0 0
  ZFS_Ctrl1:/export/CLONE_ARC_dbname_11        /ZFS/CLONEDB1/CLONE_ARCH_dbname_11        nfs     rw,hard,rsize=32768,wsize=32768,tcp,nfsvers=4,timeo=600 0 0
  ZFS_Ctrl2:/export/CLONE_ARC_dbname_12        /ZFS/CLONEDB1/CLONE_ARCH_dbname_12        nfs     rw,hard,rsize=32768,wsize=32768,tcp,nfsvers=4,timeo=600 0 0

## NFS File systems for CloneDB_2
  ZFS_Ctrl1:/export/CLONE_BAK_dbname_21        /ZFS/CLONEDB2/CLONE_DATA_dbname_21        nfs     rw,hard,rsize=32768,wsize=32768,tcp,nfsvers=4,timeo=600 0 0
  ZFS_Ctrl2:/export/CLONE_BAK_dbname_22        /ZFS/CLONEDB2/CLONE_DATA_dbname_22        nfs     rw,hard,rsize=32768,wsize=32768,tcp,nfsvers=4,timeo=600 0 0
  ZFS_Ctrl1:/export/CLONE_ARC_dbname_21        /ZFS/CLONEDB2/CLONE_ARCH_dbname_21        nfs     rw,hard,rsize=32768,wsize=32768,tcp,nfsvers=4,timeo=600 0 0
  ZFS_Ctrl2:/export/CLONE_ARC_dbname_22        /ZFS/CLONEDB2/CLONE_ARCH_dbname_22        nfs     rw,hard,rsize=32768,wsize=32768,tcp,nfsvers=4,timeo=600 0 0

#-----------------------------------------------------------------------------------------------------------------------------------------------------------------

2. modify USER Define Items of /ZFS/SCRIPTS/CloneDB/CloneDB1/CloneDB_Profile
   - ORACLE_SID=CLONEDB_SID
   - ORACLE_UNQNAME=CLONEDB_NAME
   - ORACLE_DBNAME=Backup_Database_name
   - export CTRL_NO=2        		=> This means is ZFS Control node is 2EA
   - export PROJNAME=ORCL 		=> Project Name must be matched backuped database project name

3. Apply CloneDB_Profile environments and Excute make_dir.sh file for make CloneDB's mount points
   $ . /ZFS/SCRIPTS/CloneDB/CloneDB1/CloneDB_Profile
   $ /ZFS/SCRIPTS/CloneDB/CloneDB1/make_dir.sh
   $ ls /ZFS
   $ BK_dbname_01     BK_dbname_02     CLONE_DATA_dbname_11 	  CLONE_DATA_dbname_12     CLONE_ARCH_dbname_11      CLONE_ARCH_dbname_12      LOGS       SCRIPTS

4. modify pfile in the /ZFS/SCRIPTS/CloneDB/CloneDB1/DBA/initCLONEDB1.ora

5. Now!! We are ready to start CLONEDB bring-up process using ZBRM.

6. If your Database backup from ADG target system then you should match incarnation.
   ex)  RMAN> list incarnation of database;
        RMAN> reset database to incarnation 1;

----------------------------------------------------------------------------------------------------------------------------------------------------------------

Note.

1. /ZFS/LOGS/CLONEDBx/CLONEDBx_Recover_yyyymmdd_HH.log
   /ZFS/ARCH_dbname_01/1.Backup_summary.log - Summarized information of DB status after archive log backup finished

2. check alert log
  - $ORACLE_BASE/diag/rdbms/db_name/CLONEDB1/trace/alert_CLONEDB1.log

3. If you want to change a Database Name
  - SQL> shutdown immediate
    SQL> startup mount
    $nid TARGET=SYS DBNAME=CLONEDB
    -> Input SYS account's password 
    SQL> alter database open resetlogs;

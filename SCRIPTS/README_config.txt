Start ZFS Backup configuration for ORACLE Database Backup...

1. mkdir base directory
   # mkdir /ZFS

2. copy ZBRM_vX.X.X_Date.tar to the base directory and extract 
   # cp ZBRM_v2.9.6_05Jul2021.tar /ZFS
   # cd /ZFS
   # tar xf ZBRM_v2.9.6_05Jul2021.tar
   
3. make a LOGS directoy
   # mkdir /ZFS/LOGS

4. change ownership to oracle user and group
   # chown -R oracle:oinstall /ZFS 

5. Add ZFS Appliance Controller's Backup Network IP Address to /etc/hosts

6. Add linse to .bash_profile of root user and oracle user  

###### Used for the ZFS Backup ################
  export BASEDIR=/ZFS

    if [ -f ${BASEDIR}/SCRIPTS/Profile ]; then
         . ${BASEDIR}/SCRIPTS/Profile
    fi
###############################################

7. Add ZFS file systems mount parameters to /etc/fstab or /etc/vfstab

   - NFS Mount Option for RMAN Backup

[ Linux : /etc/fstab ]
#----- NFS File systems for SAMPLE Backup -----------------------------------------------------------------------------------------------------------------------------
  ZFS_Ctrl1:/export/BAK_"DB_DIR"_01              /ZFS/BACKUP/DATA_"DB_DIR"_01               nfs     _netdev,rw,hard,rsize=1048576,wsize=1048576,tcp,nfsvers=4,timeo=600 0 0
  ZFS_Ctrl2:/export/BAK_"DB_DIR"_02              /ZFS/BACKUP/DATA_"DB_DIR"_02               nfs     _netdev,rw,hard,rsize=1048576,wsize=1048576,tcp,nfsvers=4,timeo=600 0 0
  ZFS_Ctrl1:/export/ARC_"DB_DIR"_01              /ZFS/BACKUP/ARCH_"DB_DIR"_01               nfs     _netdev,rw,hard,rsize=1048576,wsize=1048576,tcp,nfsvers=4,timeo=600 0 0
  ZFS_Ctrl2:/export/ARC_"DB_DIR"_02              /ZFS/BACKUP/ARCH_"DB_DIR"_02               nfs     _netdev,rw,hard,rsize=1048576,wsize=1048576,tcp,nfsvers=4,timeo=600 0 0

## NFS File systems for CloneDB_
  ZFS_Ctrl1:/export/CLONE_BAK_"DB_DIR"_11        /ZFS/CLONEDB1/CLONE_DATA_"DB_DIR"_11       nfs     noauto,user,rw,hard,rsize=32768,wsize=32768,tcp,nfsvers=4,timeo=600 0 0
  ZFS_Ctrl2:/export/CLONE_BAK_"DB_DIR"_12        /ZFS/CLONEDB1/CLONE_DATA_"DB_DIR"_12       nfs     noauto,user,rw,hard,rsize=32768,wsize=32768,tcp,nfsvers=4,timeo=600 0 0
  ZFS_Ctrl1:/export/CLONE_ARC_"DB_DIR"_11        /ZFS/CLONEDB1/CLONE_ARCH_"DB_DIR"_11       nfs     noauto,user,rw,hard,rsize=32768,wsize=32768,tcp,nfsvers=4,timeo=600 0 0
  ZFS_Ctrl2:/export/CLONE_ARC_"DB_DIR"_12        /ZFS/CLONEDB1/CLONE_ARCH_"DB_DIR"_12       nfs     noauto,user,rw,hard,rsize=32768,wsize=32768,tcp,nfsvers=4,timeo=600 0 0

## NFS File systems for CloneDB_2
  ZFS_Ctrl1:/export/CLONE_BAK_"DB_DIR"_21        /ZFS/CLONEDB2/CLONE_DATA_"DB_DIR"_21       nfs     noauto,user,rw,hard,rsize=32768,wsize=32768,tcp,nfsvers=4,timeo=600 0 0
  ZFS_Ctrl2:/export/CLONE_BAK_"DB_DIR"_22        /ZFS/CLONEDB2/CLONE_DATA_"DB_DIR"_22       nfs     noauto,user,rw,hard,rsize=32768,wsize=32768,tcp,nfsvers=4,timeo=600 0 0
  ZFS_Ctrl1:/export/CLONE_ARC_"DB_DIR"_21        /ZFS/CLONEDB2/CLONE_ARCH_"DB_DIR"_21       nfs     noauto,user,rw,hard,rsize=32768,wsize=32768,tcp,nfsvers=4,timeo=600 0 0
  ZFS_Ctrl2:/export/CLONE_ARC_"DB_DIR"_22        /ZFS/CLONEDB2/CLONE_ARCH_"DB_DIR"_22       nfs     noauto,user,rw,hard,rsize=32768,wsize=32768,tcp,nfsvers=4,timeo=600 0 0

#----------------------------------------------------------------------------------------------------------------------------------------------------------------------

8. Modify the Base profile /ZFS/SCRIPTS/Profile ( Database Directory name and Catatalog DB connection information )

   export DB1=ORCL
   export DB2=UPGR
   export BASEDIR=/ZFS

9. modify the Database Backup profile /ZFS/SCRIPTS/Database/DBname/ZFS_Profile 

   export BASEDIR=/ZFS
   export CTRL_NO=2        				=> This means is ZFS Control node is 2EA
   export PROJNAME=DBNAME 				=> Use project Name can help easy to know backup database name
   export ORACLE_DBNAME=DBname				=> Oracle Database Name
   export DB_NAME=DBNAME				=> We recommend using uppercase letters of Database
   export DB_DIR=db directory name                      => It will be used as backup Directory name ( We recommend using uppercase letters )
   export ORACLE_HOME=$ORACLE_BASE/product/18		 
   PROD_ARCH=/u01/oradata/DBname/Arch			=> Archive log location directory
   export DCH_NO=4					=> Number of Data file target directory  ( DCH1,DCH2,DCH3,DCH4 )

10. Excute /ZFS/SCRIPTS/make_backup_dir.sh file for make backup mount points

   $ . /ZFS/SCRIPTS/Database/"DB_DIR"/ZFS_Profile
   $ sh /ZFS/SCRIPTS/Database/"DB_DIR"/make_backup_dir.sh
   $ ls /ZFS/BACKUP
   $ DATA_"DB_DIR"_01     DATA_"DB_DIR"_02 ARCH_"DB_DIR"_01 ARCH_"DB_DIR"_02   
   
11. mount ZFS Volume and make backup target directory

   $ sh /ZFS/SCRIPTS/Database/DBname/mount_backup.sh

   ***********************************************************************************************
    CAUTION!!! Apply this DB environments variable ZFS_Profile first before executing this command.
    Mount command need root privileges.
    Please input root password !!!
    Password:*********
   ***********************************************************************************************
    Filesystem                       Type    Size  Used  Avail Use% Mounted on
   -----------------------------------------------------------------------------------------------
    ZFS_Ctrl1:/export/ARC_"DB_DIR"_01   nfs     19G  312M   19G   2% /ZFS/BACKUP/ARCH_"DB_DIR"_01
    ZFS_Ctrl2:/export/ARC_"DB_DIR"_02   nfs     23G  119M   23G   1% /ZFS/BACKUP/ARCH_"DB_DIR"_02
    ZFS_Ctrl1:/export/BAK_"DB_DIR"_01   nfs     20G  1.2G   19G   6% /ZFS/BACKUP/DATA_"DB_DIR"_01
    ZFS_Ctrl2:/export/BAK_"DB_DIR"_02   nfs     23G  635M   23G   3% /ZFS/BACKUP/DATA_"DB_DIR"_02
   ***********************************************************************************************

12. Excute /ZFS/SCRIPTS/make_backup_dir.sh file again for make backup target directories.
    $ sh /ZFS/SCRIPTS/Database/DB_DIR/make_backup_dir.sh
    $ ls /ZFS/BACKUP/DATA_DB_DIR_01
         DCH1 	DCH3   TEMP	
    $ ls /ZFS/BACKUP/DATA_DB_DIR_02
         DCH2 	DCH4 

13. copy ssh key strings in the ~oracle/.ssh/id_rsa.pub to create Snapshots without input password after finished backup.

    If the rsa key file does not exist, create it with the ssh-keygen command.
    $ ssh-keygen -t rsa
    $ cat ~oracle/.ssh/id_rsa.pub
      -> copy rsa key strings

     Open the WEB Browser - https://ZFS_Ctrl1_ip:215 
      - Configuration -> PREFERENCES -> + SSH Public Keys -> Type : RSA, SSH Public key : paste key strings
       
14. Change file name to start DB_NAME~~.sh in /ZFS/SCRIPTS/Database/DB_DIR/RMAN/

15. Modify /ZFS/SCRIPTS/Database/DB_DIR/RMAN/DB_NAME_*.sh

16. Now!! We can backup Database to ZFS Appliance.
    using zbrm.sh or crontab 

-------------------------------------------------------------------------------------------------------------------------------------

Notes.

1. Config file of ZFS BRM 
  - Initial Profile for Backup 	: /ZFS/SCRIPTS/Profile
  - Initial Profile for CloneDB : /ZFS/SCRIPTS/CloneDB/CloneDB_Profile 

  - DBA Directory (Backup)   	: /ZFS/SCRIPTS/Database/DB1/RMAN  
  - DBA Directory (Clone DB) 	: /ZFS/SCRIPTS/CloneDB/CloneDB1/DBA  

2. LOG files
  - Base Log file Directory :  /ZFS/LOGS
  - DB1 Log file Directory  :  /ZFS/LOGS/DB1
  - CLONE DB1 Log directory :  /ZFS/LOGS/CLONEDB1
  - CLONE DB2 Log directory :  /ZFS/LOGS/CLONEDB2

3. Management Tool
   - /ZFS/SCRIPTS/ZBRM_main.sh   		    : Main script file
   - /ZFS/SCRIPTS/Profile 		  	    : Help start zbrm.sh, show status from catalogdb and crontab schedule job	
   - /ZFS/SCRIPTS/Database/"DB_DIR1"/ZFS_Profile    : Database1 information & parameter file 
   - /ZFS/SCRIPTS/Database/"DB_DIR2"/ZFS_Profile    : Database2 information & parameter file 
   - /ZFS/SCRIPTS/CloneDB/Menu_CloneDB.sh    	    : CloneDB path 
   - /ZFS/SCRIPTS/CloneDB/CLONEDB1/Menu_CloneDB.sh  : CloneDB1 Bring-up Menu
   - /ZFS/SCRIPTS/CloneDB/CLONEDB2/Menu_CloneDB.sh  : CloneDB2 Bring-up Menu

4. Change SQL Prompt of CLONEDB
    $ORACLE_HOME/sqlplus/admin/glogin.sql
    set sqlprompt "_user'@'_connect_identifier > "

5. Enable dNFS and check status
    $cd $ORACLE_HOME/rdbms/lib
    $make -f ins_rdbms.mk dnfs_on
    SQL> set lines 180
    SQL> col SVRNAME for a10
    SQL> col DIRNAME for a30
    SQL> col NFSVERSION for a10
    SQL> col RDMAENABLE for a10
    SQL> col SECURITY for a8 
    SQL> select * from v$dnfs_servers; 
    SQL> select * from v$dnfs_files;
    SQL> select PNUM, NFS_READLINK,NFS_READ, NFS_WRITE,NFS_LINK, NFS_MOUNT,NFS_READBYTES,NFS_WRITEBYTES from v$dnfs_stats order by PNUM;

6. Enable Archive log mode
    SQL> shutdown immediate
    SQL> startup mount
    SQL> alter database archivelog;
    SQL> ALTER SYSTEM SET db_recovery_file_dest='/u01/oradata/DBname/Arch'; or
    SQL> ALTER SYSTEM SET log_archive_dest_1='LOCATION=/u01/oradata/DBname/Arch';
    SQL> ALTER SYSTEM SET log_archive_format='arch_%t_%s_%r.arc' SCOPE=spfile;
    SQL> alter database open;
    SQL> alter system switch logfile;

7. Enable Block Change Tracking 
    SQL> alter database enable block change tracking  using file '/datafile/bct.dbf' ;
    SQL> select filename, status, bytes from v$block_change_tracking;

8. Perform these steps to enable Hybrid Columnar Compression (HCC) on Direct NFS Client:
    Ensure that SNMP is enabled on the ZFS storage server. For example
    $ snmpget -v1 -c public cdrwbko1-10g .1.3.6.1.4.1.42.2.225.1.4.2.0
    -> SNMPv2-SMI::enterprises.42.2.225.1.4.2.0 = STRING: "Sun ZFS Storage 7350"

9. Edit crontab " crontab -e " as root or oracle user
00 18 02 01 *             sh /ZFS/SCRIPTS/Database/"DB_DIR"/RMAN/SCHEDULE/RMAN_Full.sh         DB_DIR
30 01 03 01 *             sh /ZFS/SCRIPTS/Database/"DB_DIR"/RMAN/SCHEDULE/RMAN_Incr_Level0.sh  DB_DIR
30 00,12 *  *  0-5        sh /ZFS/SCRIPTS/Database/"DB_DIR"/RMAN/SCHEDULE/RMAN_Incr_Level1.sh  DB_DIR
30 02,14 *  *  0-5        sh /ZFS/SCRIPTS/Database/"DB_DIR"/RMAN/SCHEDULE/RMAN_Merge.sh        DB_DIR
30 02,12 *  *  0-5        sh /ZFS/SCRIPTS/Database/"DB_DIR"/RMAN/SCHEDULE/RMAN_Incr_Merge.sh   DB_DIR
30 12,18 *  *  *          sh /ZFS/SCRIPTS/Database/"DB_DIR"/RMAN/SCHEDULE/RMAN_ArchiveLog.sh   DB_DIR

10. $ORACLE_HOME/dbs/oranfstab
server: ZFS_Ctrl1
local: 192.168.10.1 path: 192.168.10.21
export: /export/BAK_"DB_DIR"_01 mount: /ZFS/BACKUP/DATA_"DB_DIR"_01
server: ZFS_Ctrl2
local: 192.168.10.2 path: 192.168.10.22
export: /export/BAK_"DB_DIR"_02 mount: /ZFS/BACKUP/DATA_"DB_DIR"_02

----- Program Directory Structure ----------------------------------------------------------------------------

/ZFS ------- BACKUP ------- DATA_ORCL_01 ----------- DCH1
	|	|	|			  |- DCH3
	|	|	|			  |- TEMP
	|	|	|
       	|       |     	|-- DATA_ORCL_02 ----------- DCH2
	|	|	|			  |- DCH4
	|	|	|
       	|       |     	|-- ARCH_ORCL_01 ----------- ORCL_2020_0222 	
	|	|	|                      	  |- ORCL_0220_0223
	|	|	|
       	|       |     	|-- ARCH_ORCL_02 ----------- ORCL_2020_0222
	|	|				  |- ORCL_2020_0223
	|	|
	|	|	
	|	|---------- DATA_UPGR_01 ----------- DCH1
	|		|			  |- DCH3
	|		|
       	|            	|-- DATA_UPGR_02 ----------- DCH2
	|		|			  |- DCH4
	|		|
       	|            	|-- ARCH_UPGR_01 ----------- UPGR_2020_0222 	
	|		|                      	  |- UPGR_0220_0223
	|		|
       	|            	|-- ARCH_UPGR_02 ----------- UPGR_2020_0222
	|					  |- UPGR_2020_0223
	|
	|
	|--- CLONEDB1 ----- CLONE_DATA_ORCL_11 ----- DCH1
	|		|			  |- DCH3
	|		|
       	|            	|-- CLONE_DATA_ORCL_12 ----- DCH2
	|		|			  |- DCH4
	|		|
       	|            	|-- CLONE_ARCH_ORCL_11 ----- ORCL_2020_0222 	
	|		|                      	  |- ORCL_0220_0223
	|		|
       	|            	|-- CLONE_ARCH_ORCL_12 ----- ORCL_2020_0222
	|					  |- ORCL_2020_0223
	| 
	|--- CLONEDB2 ----- CLONE_DATA_UPGR_21 ----- DCH1
	|		|			  |- DCH3
	|		|
       	|            	|-- CLONE_DATA_UPGR_22 ----- DCH2
	|		|			  |- DCH4
	|		|
       	|            	|-- CLONE_ARCH_UPGR_21 ----- UPGR_2020_0222 	
	|		|                      	  |- UPGR_0220_0223
	|		|
       	|            	|-- CLONE_ARCH_UPGR_22 ----- UPGR_2020_0222
	|					  |- UPGR_2020_0223
	|
	|--- LOGS --------- ORCL ------------------- ORCL_2020_0222 
	| 		|      		  	  |- ORCL_2020_0223
	|		|			  |
	|		|-- UPGR ------------------- UPGR_2020_0222 
	| 		|		  	  |- UPGR_2020_0223
	|		|-- CLONEDB1 
	|		|-- CLONEDB2
	|
	|--- SCRIPTS ------ CloneDB ---------------- CLONEDB1 ------- DBA
  		    	| 			  |- CLONEDB2 ------- DBA
			|
			|-- Database --------------- ORCL ----------- RMAN ------------- SCHEDULE
			|			  |- UPGR ----------- RMAN ------------- SCHEDULE
			|
			|-- SHELL 
			|	
			|-- SQL
			|
			|-- ZFS
			|
			|-- TechNote

--------------------------------------------------------------------------------------------------------------

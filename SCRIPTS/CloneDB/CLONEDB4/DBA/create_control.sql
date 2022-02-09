STARTUP NOMOUNT 
CREATE CONTROLFILE SET DATABASE CLONEDB4  RESETLOGS  ARCHIVELOG 
    MAXLOGFILES 16 
    MAXLOGMEMBERS 3 
    MAXDATAFILES 15000 
    MAXINSTANCES 8 
    MAXLOGHISTORY 500 
LOGFILE 
  GROUP 1 ('/ZFS/CLONEDB4/DATA_LABDB_FULL_41/redolog01.log') SIZE 512M BLOCKSIZE 512, 
  GROUP 2 ('/ZFS/CLONEDB4/DATA_LABDB_FULL_42/redolog02.log') SIZE 512M BLOCKSIZE 512, 
  GROUP 3 ('/ZFS/CLONEDB4/DATA_LABDB_FULL_41/redolog03.log') SIZE 512M BLOCKSIZE 512, 
  GROUP 4 ('/ZFS/CLONEDB4/DATA_LABDB_FULL_42/redolog04.log') SIZE 512M BLOCKSIZE 512  
DATAFILE
 '/ZFS/CLONEDB4/DATA_LABDB_FULL_41/DCH1/data_D-LABDB_I-2079113981_TS-SYSTEM_FNO-1_2hvrd4nb', 
 '/ZFS/CLONEDB4/DATA_LABDB_FULL_42/DCH4/data_D-LABDB_I-2079113981_TS-SYSAUX_FNO-2_2kvrd4nb', 
 '/ZFS/CLONEDB4/DATA_LABDB_FULL_42/DCH2/data_D-LABDB_I-2079113981_TS-UNDOTBS1_FNO-3_2ivrd4nb', 
 '/ZFS/CLONEDB4/DATA_LABDB_FULL_41/DCH3/data_D-LABDB_I-2079113981_TS-UNDOTBS2_FNO-4_2jvrd4nb', 
 '/ZFS/CLONEDB4/DATA_LABDB_FULL_41/DCH5/data_D-LABDB_I-2079113981_TS-USERS_FNO-5_2lvrd4n8';  

-- The following are current System-scope REDO Log Archival related
-- parameters and can be included in the database initialization file.
--
-- LOG_ARCHIVE_DEST=''
-- LOG_ARCHIVE_DUPLEX_DEST=''
--
-- LOG_ARCHIVE_FORMAT=arch_%s_%t_%r.arc
--
-- DB_UNIQUE_NAME="CLONEDB2"
--
-- LOG_ARCHIVE_CONFIG='SEND, RECEIVE, NODG_CONFIG'
-- LOG_ARCHIVE_MAX_PROCESSES=4
-- STANDBY_FILE_MANAGEMENT=MANUAL
-- STANDBY_ARCHIVE_DEST=?/dbs/arch
-- FAL_CLIENT=''
-- FAL_SERVER=''
--
-- LOG_ARCHIVE_DEST_1='LOCATION=/ZFS/CLONEDB2/CLONE_ARCH_CDB1_21'
-- LOG_ARCHIVE_DEST_1='OPTIONAL REOPEN=300 NODELAY'
-- LOG_ARCHIVE_DEST_1='ARCH NOAFFIRM NOVERIFY SYNC'
-- LOG_ARCHIVE_DEST_1='REGISTER NOALTERNATE NODEPENDENCY'
-- LOG_ARCHIVE_DEST_1='NOMAX_FAILURE NOQUOTA_SIZE NOQUOTA_USED NODB_UNIQUE_NAME'
-- LOG_ARCHIVE_DEST_1='VALID_FOR=(PRIMARY_ROLE,ONLINE_LOGFILES)'
-- LOG_ARCHIVE_DEST_STATE_1=ENABLE

--
-- Below are two sets of SQL statements, each of which creates a new
-- control file and uses it to open the database. The first set opens
-- the database with the NORESETLOGS option and should be used only if
-- the current versions of all online logs are available. The second
-- set opens the database with the RESETLOGS option and should be used
-- if online logs are unavailable.
-- The appropriate set of statements can be copied from the trace into
-- a script file, edited as necessary, and executed when there is a
-- need to re-create the control file.
--
--     Set #1. NORESETLOGS case
--
-- The following commands will create a new control file and use it
-- to open the database.
-- Data used by Recovery Manager will be lost.
-- Additional logs may be required for media recovery of offline
-- Use this only if the current versions of all online logs are
-- available.
-- WARNING! The current control file needs to be checked against
-- the datafiles to insure it contains the correct files. The
-- commands printed here may be missing log and/or data files.
-- Another report should be made after the database has been
-- successfully opened.

-- After mounting the created controlfile, the following SQL
-- statement will place the database in the appropriate
-- protection mode:
--  ALTER DATABASE SET STANDBY DATABASE TO MAXIMIZE PERFORMANCE

STARTUP NOMOUNT
CREATE CONTROLFILE REUSE DATABASE "CLONEDB2" NORESETLOGS  ARCHIVELOG
    MAXLOGFILES 16
    MAXLOGMEMBERS 3
    MAXDATAFILES 15000
    MAXINSTANCES 8
    MAXLOGHISTORY 584
LOGFILE
  GROUP 1 '/ZFS/CLONEDB2/CLONE_DATA_CDB1_21/redolog01.log'  SIZE 100M BLOCKSIZE 512,
  GROUP 2 '/ZFS/CLONEDB2/CLONE_DATA_CDB1_22/redolog02.log'  SIZE 100M BLOCKSIZE 512,
  GROUP 3 '/ZFS/CLONEDB2/CLONE_DATA_CDB1_21/redolog03.log'  SIZE 100M BLOCKSIZE 512
-- STANDBY LOGFILE
DATAFILE
  '/ZFS/CLONEDB2/CLONE_DATA_CDB1_21/DCH1/data_D-CDB1_I-893436478_TS-SYSTEM_FNO-1_01updujr',
  '/ZFS/CLONEDB2/CLONE_DATA_CDB1_22/DCH2/data_D-CDB1_I-893436478_TS-SYSAUX_FNO-3_02updujr',
  '/ZFS/CLONEDB2/CLONE_DATA_CDB1_21/DCH3/data_D-CDB1_I-893436478_TS-UNDOTBS1_FNO-5_03updujr',
  '/ZFS/CLONEDB2/CLONE_DATA_CDB1_22/DCH6/data_D-CDB1_I-893436478_TS-USERS_FNO-6_06updujr'
CHARACTER SET US7ASCII
;

-- Commands to re-create incarnation table
-- Below log names MUST be changed to existing filenames on
-- disk. Any one log file from each branch can be used to
-- re-create incarnation records.
-- ALTER DATABASE REGISTER LOGFILE '/ZFS/CLONEDB2/CLONE_ARCH_CDB1_21/arch_1_1_919719038.arc';
-- Recovery is required if any of the datafiles are restored backups,
-- or if the last shutdown was not normal or immediate.
RECOVER DATABASE

-- All logs need archiving and a log switch is needed.
ALTER SYSTEM ARCHIVE LOG ALL;

-- Database can now be opened normally.
ALTER DATABASE OPEN;

-- No tempfile entries found to add.
--
--     Set #2. RESETLOGS case
--
-- The following commands will create a new control file and use it
-- to open the database.
-- Data used by Recovery Manager will be lost.
-- The contents of online logs will be lost and all backups will
-- be invalidated. Use this only if online logs are damaged.
-- WARNING! The current control file needs to be checked against
-- the datafiles to insure it contains the correct files. The
-- commands printed here may be missing log and/or data files.
-- Another report should be made after the database has been
-- successfully opened.

-- After mounting the created controlfile, the following SQL
-- statement will place the database in the appropriate
-- protection mode:
--  ALTER DATABASE SET STANDBY DATABASE TO MAXIMIZE PERFORMANCE

STARTUP NOMOUNT
CREATE CONTROLFILE REUSE DATABASE "CLONEDB2" RESETLOGS  ARCHIVELOG
    MAXLOGFILES 16
    MAXLOGMEMBERS 3
    MAXDATAFILES 15000
    MAXINSTANCES 8
    MAXLOGHISTORY 584
LOGFILE
  GROUP 1 '/ZFS/CLONEDB2/CLONE_DATA_CDB1_21/redolog01.log'  SIZE 100M BLOCKSIZE 512,
  GROUP 2 '/ZFS/CLONEDB2/CLONE_DATA_CDB1_22/redolog02.log'  SIZE 100M BLOCKSIZE 512,
  GROUP 3 '/ZFS/CLONEDB2/CLONE_DATA_CDB1_21/redolog03.log'  SIZE 100M BLOCKSIZE 512
-- STANDBY LOGFILE
DATAFILE
  '/ZFS/CLONEDB2/CLONE_DATA_CDB1_21/DCH1/data_D-CDB1_I-893436478_TS-SYSTEM_FNO-1_01updujr',
  '/ZFS/CLONEDB2/CLONE_DATA_CDB1_22/DCH2/data_D-CDB1_I-893436478_TS-SYSAUX_FNO-3_02updujr',
  '/ZFS/CLONEDB2/CLONE_DATA_CDB1_21/DCH3/data_D-CDB1_I-893436478_TS-UNDOTBS1_FNO-5_03updujr',
  '/ZFS/CLONEDB2/CLONE_DATA_CDB1_22/DCH6/data_D-CDB1_I-893436478_TS-USERS_FNO-6_06updujr'
CHARACTER SET US7ASCII
;

-- Commands to re-create incarnation table
-- Below log names MUST be changed to existing filenames on
-- disk. Any one log file from each branch can be used to
-- re-create incarnation records.
-- ALTER DATABASE REGISTER LOGFILE '/ZFS/CLONEDB2/CLONE_ARCH_CDB1_21/arch_1_1_919719038.arc';
-- Recovery is required if any of the datafiles are restored backups,
-- or if the last shutdown was not normal or immediate.
RECOVER DATABASE USING BACKUP CONTROLFILE

-- Database can now be opened zeroing the online logs.
ALTER DATABASE OPEN RESETLOGS;

-- No tempfile entries found to add.
--

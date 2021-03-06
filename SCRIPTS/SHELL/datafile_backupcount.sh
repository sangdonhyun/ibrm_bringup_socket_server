#!/bin/sh
DB_DIR=$1
. ${BASEDIR}/SCRIPTS/Database/${DB_DIR}/ZFS_Profile

#-------------------------- Sum of total Datafile count -------------------------------------------------------------------------------

sqlplus -s / as sysdba << EOF > ${ZFS_TEMP_DIR}/${DB_NAME}_datafile.out
set head off
select count(name) from v\$datafile;
EOF

grep -v '^ *$' ${ZFS_TEMP_DIR}/${DB_NAME}_datafile.out |awk '{print $1}' > ${ZFS_TEMP_DIR}/${DB_NAME}_FILE.out
FILE=`cat ${ZFS_TEMP_DIR}/${DB_NAME}_FILE.out`

echo ""
echo "------------------------------------------------------------------------------------------------------------------------------------------------- "
echo ""

BKLEV=`cat ${ZFS_TEMP_DIR}/${DB_NAME}_BKLEV.out`

#--------------------------------------------------------------------------------------------------------------------------------------

if [ $BKLEV = Full ];
   then
      BTIME=`cat ${ZFS_TEMP_DIR}/${DB_NAME}_FTIME.out`
      cp ${ZFS_TEMP_DIR}/${DB_NAME}_FTIME.out ${ZFS_TEMP_DIR}/${DB_NAME}_BTIME.out

rman target / nocatalog  << EOF > /${ZFS_TEMP_DIR}/${DB_NAME}_FL_backupdata.out
LIST COPY TAG $RMAN_TAG_FULL completed after "to_date('$BTIME','yyyy/mm/dd_hh24:mi:ss')";
EOF

   grep "Name:" ${ZFS_TEMP_DIR}/${DB_NAME}_FL_backupdata.out |grep -v "Container ID" |wc -l > ${ZFS_TEMP_DIR}/${DB_NAME}_DATA.out
   echo $FTIME > ${ZFS_TEMP_DIR}/${DB_NAME}_BTIME.out

#--------------------------------------------------------------------------------------------------------------------------------------

elif [ $BKLEV = Level0 ];
     then
     BTIME=`cat /${ZFS_TEMP_DIR}/${DB_NAME}_L0TIME.out`
     cp ${ZFS_TEMP_DIR}/${DB_NAME}_L0TIME.out ${ZFS_TEMP_DIR}/${DB_NAME}_BTIME.out

rman target / nocatalog  << EOF > ${ZFS_TEMP_DIR}/${DB_NAME}_L0_backupdata.out
LIST COPY TAG $RMAN_TAG_INCR completed after "to_date('$BTIME','yyyy/mm/dd_hh24:mi:ss')";
EOF

     grep "Name:" ${ZFS_TEMP_DIR}/${DB_NAME}_L0_backupdata.out |grep -v "cf_" |grep -v "Container ID" |wc -l > ${ZFS_TEMP_DIR}/${DB_NAME}_DATA.out

#--------------------------------------------------------------------------------------------------------------------------------------

  elif  [ $BKLEV = Level1 ]
    then
      BTIME=`cat ${ZFS_TEMP_DIR}/${DB_NAME}_L1TIME.out`
      cp ${ZFS_TEMP_DIR}/${DB_NAME}_L1TIME.out ${ZFS_TEMP_DIR}/${DB_NAME}_BTIME.out

rman target / nocatalog  << EOF > ${ZFS_TEMP_DIR}/${DB_NAME}_L1_backupdata.out
LIST BACKUP TAG $RMAN_TAG_INCR completed after "to_date('$BTIME','yyyy/mm/dd_hh24:mi:ss')";
EOF

   grep "Incr" ${ZFS_TEMP_DIR}/${DB_NAME}_L1_backupdata.out |grep -v DISK |awk '{print $4}' | uniq | wc -l > ${ZFS_TEMP_DIR}/${DB_NAME}_DATA.out

#--------------------------------------------------------------------------------------------------------------------------------------

  elif  [ $BKLEV = Merge ]
    then
      BTIME=`cat ${ZFS_TEMP_DIR}/${DB_NAME}_MTIME.out`
      cp ${ZFS_TEMP_DIR}/${DB_NAME}_MTIME.out ${ZFS_TEMP_DIR}/${DB_NAME}_BTIME.out

rman target / nocatalog  << EOF > ${ZFS_TEMP_DIR}/${DB_NAME}_MG_backupdata.out
LIST COPY TAG $RMAN_TAG_INCR completed after "to_date('$BTIME','yyyy/mm/dd_hh24:mi:ss')";
EOF

   grep "Name:" ${ZFS_TEMP_DIR}/${DB_NAME}_MG_backupdata.out |grep -v "Container ID" |wc -l > ${ZFS_TEMP_DIR}/${DB_NAME}_DATA.out

else
   echo " You need to check RMAN backup scripts in $RMANDIR "
fi

#--------------------------------------------------------------------------------------------------------------------------------------

grep -v '^ *$' ${ZFS_TEMP_DIR}/${DB_NAME}_DATA.out |awk '{print $1}' > ${ZFS_TEMP_DIR}/${DB_NAME}_BACKUP
BACKUP=`cat ${ZFS_TEMP_DIR}/${DB_NAME}_BACKUP`

echo " Number of completed data files of RMAN [ $BKLEV ] after $BTIME  [ $BACKUP / $FILE ]"
echo ""
echo "------------------------------------------------------------------------------------------------------------------------------------------------- "

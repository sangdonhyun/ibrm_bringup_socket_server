#!/bin/bash

 mkdir -p $LOGDIR

 if [ ! -d ${BACKUPDB_LOG} ]
        then
	   mkdir -p ${BACKUPDB_LOG}

 else if [ -d ${BACKUP_DATA_DIR1} ] 
 then

 i=1
 j=1

     while [ $i -le $DSHARE_NO ]
     do
	echo ""
         while [ $j -le $DCH_NO ]
         do
            DCHDIR="mkdir -p \${BACKUP_DATA_DIR${i}}/DCH${j} " ; echo $DCHDIR | sh
            j=$(( $j + $DSHARE_NO ))
         done
        i=$(( $i + 1 ))
        j=$i
     done
  mkdir -p ${ZFS_TEMP_DIR}

 else 
 k=1

     while [ $k -le $DSHARE_NO ]
       do 
        BAKDIR="mkdir -p \${BACKUP_DATA_DIR${k}} " ; echo $BAKDIR | sh
        ARCDIR="mkdir -p \${BACKUP_ARCH_DIR${k}} " ; echo $ARCDIR | sh
           k=$(( $k + 1 )) 
       done
 fi
fi

echo ""
echo "-----------  List [ ${BACKUP_DATA_DIR1} ] ------------------------"
     ls -al ${BACKUP_DATA_DIR1}
echo "---------------------------------------------------------------------"
echo ""
echo "-----------  List [ ${BACKUP_DATA_DIR2} ] ------------------------"
     ls -al ${BACKUP_DATA_DIR2}
echo "---------------------------------------------------------------------"

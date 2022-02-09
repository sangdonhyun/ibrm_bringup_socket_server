#!/bin/sh

mkdir -p ${CLONE_DATA_DIR}
mkdir -p ${LOGDIR}

i=1
while [ $i -le $DSHARE_NO ]
do
        ZFS="mkdir  \${CLONE_DATA_DIR${i}} " ; echo $ZFS | sh 
        ZFS1="mkdir \${CLONE_ARCH_DIR${i}} " ; echo $ZFS1 | sh 
        i=$(( $i + 1 ))
done

echo ""
echo " ------  List [ ${CLONE_DATA_DIR} ] ------------------------------------"
     ls -al ${CLONE_DATA_DIR} |grep ${BK_DATA_DIR} |grep CLONE
echo " -----------------------------------------------------------------------"

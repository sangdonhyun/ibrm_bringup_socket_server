#!/bin/sh

export RUN_USER=`id |cut -d "(" -f2 |cut -d ")" -f1`

if [ "$RUN_USER" = "root" ]
 then
        su - $ORACLE_USER -c "${SCRDIR}/ZBRM_main.sh "
 else
        ${SHELL}  -c "${SCRDIR}/ZBRM_main.sh "

 fi
exit 


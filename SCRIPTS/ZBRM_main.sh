#!/bin/bash

while true
do
. ${BASEDIR}/SCRIPTS/Profile

# Main Menu
  clear
  echo "======================================================="
  echo " Oracle ZFS Appliance Backup & Recovery Manager v2.9.6 "
  echo "======================================================="
  echo " 1. [ $DB1 ] ORACLE 18c RMAN Image Backup "
  echo " "
#  echo " 2. [ $DB2 ] ORACLE 12c RMAN Image Backup "
#  echo " "
  echo " 2. List Database Summary from RMAN Catalog DB "
  echo " "
  echo " 3. Create CLONE_DB from ZFS Backup Sanpshot"
  echo " "
  echo "[Q] Exit "
  echo "-------------------------------------------------------"
  echo " "
  echo -n " Enter your selection : "
  read input

       case ${input} in
    1) ${SHELL} ${DB1DIR}/Menu.sh ${DB1} ;;
#    2) ${SHELL} ${DB2DIR}/Menu.sh ${DB2};;
    2) ${SHELL} ${SHELLDIR}/list_db_catalog.sh $CAT_ORACLE_HOME $cat_user $cat_pass $cat_db
       read -p "Select Database Number :" dbnum
       if [[ $dbnum =~ ^[0-9]+$ ]]
          then
      	   ${SHELL} ${SHELLDIR}/list_backup_history.sh $cat_user $cat_pass $cat_db $dbnum
      	  echo ""
    	  echo " Press ENTER to return to main menu ..."
    	  read
        else
    	  echo
    	  echo " !!! Enter Number !!!"
    	  echo
        fi
        ;;
    3) ${SHELL} ${CLONE_BASEDIR}/Menu_CloneDB.sh ;;

    q) echo " Exit Oracle ZFS Appliance Backup & Recovery Manager "
       exit
    ;;
      esac
done

#!/bin/sh

while true
do
. ${CLONE_BASEDIR}/CloneDB_Profile

   clear
   echo "=================================================================="
   echo " Oracle ZFS CloneDB Bring-up Menu  	      "
   echo "=================================================================="
   echo " 1. CLONEDB1 Bring-up Management [ Backup DB NAME - ${CLONEDB1_NAME} ] "
   echo " "
   echo " 2. CLONEDB2 Bring-up Management [ Backup DB NAME - ${CLONEDB2_NAME} ] "
   echo " "
   echo " 3. CLONEDB3 Bring-up Management [ Backup DB NAME - ${CLONEDB3_NAME} ] "
   echo " "
   echo " 4. CLONEDB4 Bring-up Management [ Backup DB NAME - ${CLONEDB4_NAME} ] "
   echo " "
   echo " [q] - Return to the Main Menu                    "
   echo "------------------------------------------------------------------"
   echo " "
   echo -n "Enter your selection : "
    read answer

      case ${answer} in
       1) ${SHELL} ${CLONEDIR1}/Menu_CloneDB.sh ;;
       2) ${SHELL} ${CLONEDIR2}/Menu_CloneDB.sh ;;
       3) ${SHELL} ${CLONEDIR3}/Menu_CloneDB.sh ;;
       4) ${SHELL} ${CLONEDIR4}/Menu_CloneDB.sh ;;
       q) exit 
         ;;
        esac
                echo -n " Enter return to continue : [Return]"
        read input
done


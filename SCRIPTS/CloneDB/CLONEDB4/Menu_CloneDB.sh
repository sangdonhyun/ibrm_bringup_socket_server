#!/bin/sh

while true
do
. ${CLONEDIR4}/CloneDB_Profile

  clear
  echo "=========================================================================="
  echo " [${BK_DBNAME}] - [${ORACLE_SID}] Bring-up Management from ZFS Backup Image !!"
  echo "=========================================================================="
  echo "    1.  List of Snapshot Backup Data "
  echo " "
  echo "    2.  Create CLONE Data Image from ZFS Backup Snapshot "
  echo " "
  echo "    3.  Create CLONE Archive Log Image from ZFS Backup Snapshot "
  echo " "
  echo "    4.  List of Exported Filesystems from PROJECT "
  echo " "
  echo "    5.  NFS mount CLONE Images from ZFS Backup Appliance "
  echo " "
  echo "    6.  CLONEDB Bring-up Menu - ( DBA Role ) "
  echo " "
  echo "    7.  Umount NFS CLONE Images (Data, Archive) "
  echo " "
  echo "    8.  Delete All of ZFS CLONE Image (Data, Archive) "
  echo " "
  echo "    9.  Delete ZFS CLONE Data Image "
  echo " "
  echo "    10. Delete ZFS CLONE Archive Log Image "
  echo " "
  echo "    [q] - Return to the Previous Menu "
  echo "--------------------------------------------------------------------------"
  echo -n "    Enter your selection : "

read answer
  case ${answer} in
      1) ${SHELL} ${SHELLDIR}/run_show_clonesnap.sh ;;
      2) ${SHELL} ${SHELLDIR}/run_create_data_snap.sh ;; 
      3) ${SHELL} ${SHELLDIR}/run_create_arch_snap.sh ;; 
      4) ${SHELL} ${SHELLDIR}/run_show_clonefs.sh ;;
      5) if [ -f "${SHELLDIR}/mount_clone.sh" ]
         then
                echo -n "    Please enter [y] to mount ${ORACLE_SID} file system : "
                read input
                input=`echo $input | tr '[a-z]' '[A-Z]'`
                if [ "$input" = Y ]
                then
                        ${SHELL} ${SHELLDIR}/mount_clone.sh $ORACLE_SID 
                else
                        echo "Input was canceled"
                fi
        else
                echo "The mount script file doesn't exist."
                echo "Please check script file location."

        fi
        ;;

      6) ${SHELL} ${DBADIR}/Menu_DBA.sh ;;
      7) if [ -f "${SHELLDIR}/umount_clone.sh" ]
         then
                echo "    CAUTION - You must shutdown ${ORACLE_SID} before this umount step!!!! "
                echo -n "    Please enter [y] to umount CLONEDB file system : "
                read input
                input=`echo $input | tr '[a-z]' '[A-Z]'`
                if [ "$input" = Y ]
                then
                        ${SHELL} ${SHELLDIR}/umount_clone.sh $ORACLE_SID
                else
                        echo "Input was canceled"
                fi
        else
                echo "The mount script file doesn't exist."
                echo "Please check script file location."

        fi
        ;;

      8) ${SHELL} ${SHELLDIR}/run_del_snapclone.sh ;;
      9) ${SHELL} ${SHELLDIR}/run_del_data_snapclone.sh ;;
     10) ${SHELL} ${SHELLDIR}/run_del_arch_snapclone.sh ;;
      q) exit
       ;;
   esac
                echo -n "Enter return to continue : [Return]"
  	read input
done

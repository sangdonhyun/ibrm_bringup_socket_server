while true
do
  clear
  echo "======================================================================="
  echo " Mangement Snapshot Data of the Oracle ZFS Backup Appliance !!!"
  echo "======================================================================="
  echo " 1. List Snapshot of Backup Data "
  echo ""
  echo " 2. List of Exported Filesystems from PROJECT [ ${DATA_PROJNAME} ]"
  echo ""
  echo " 3. Create Manual Data Snapshot "
  echo ""
  echo " 4. Create Manual Archive Log Snapshot "
  echo ""
  echo " 5. Delete to the Selected Data Snapshot "
  echo ""
  echo " 6. Delete to the Selected Archive Log Snapshot "
  echo ""
  echo " 7. Delete to the Selected Clone Image "
  echo ""
  echo " 8. Change Data Snapshot Name "
  echo ""
  echo " 9. Change Archive Log Snapshot Name "
  echo ""
  echo " [q] - Return to the Main Menu "
  echo "-----------------------------------------------------------------------"
  echo ""
  echo -n "Enter your selection : "
  read answer
    case ${answer} in
      	1) ${SHELL} ${SHELLDIR}/run_show_PRODsnap.sh ;;
      	2) ${SHELL} ${SHELLDIR}/run_showfs.sh ;;
      	3) ${SHELL} ${SHELLDIR}/run_manual_data_snap.sh ;;
      	4) ${SHELL} ${SHELLDIR}/run_manual_arch_snap.sh ;;
      	5) ${SHELL} ${SHELLDIR}/run_manual_del_data_snap.sh ;;
      	6) ${SHELL} ${SHELLDIR}/run_manual_del_arch_snap.sh ;;
      	7) ${SHELL} ${SHELLDIR}/run_manual_del_clone.sh ;;
      	8) ${SHELL} ${SHELLDIR}/run_rename_data_snap.sh ;;
      	9) ${SHELL} ${SHELLDIR}/run_rename_arch_snap.sh ;;

      q) exit ;;
  esac
  echo -n "Enter return to continue : [Return]"
  read input
done

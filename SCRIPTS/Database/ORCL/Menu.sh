#!/bin/sh
DB_DIR=$1
. ${SCRDIR}/Database/${DB_DIR}/ZFS_Profile
while true
do
  clear
  echo "======================================================================="
  echo " [${DB_DIR}] - DB Backup Mangement to ZFS Storage !! "
  echo "======================================================================="
  echo " 1. Backup RMAN Incremental Level0 (Full) "
  echo " "
  echo " 2. Backup RMAN Incremental Level1 "
  echo " "
  echo " 3. RMAN Incremental Merge Job "
  echo " "
  echo " 4. Backup Archive Log "
  echo " "
  echo " 5. Show RMAN Backup Status & History "
  echo " "
  echo " 6. List of the Backed up Snapshot Data "
  echo " "
  echo " 7. Check the RMAN Backup Process and File Progress "
  echo " "
  echo " 8. Check Datafile Creation History "
  echo " "
  echo " 9. Cancel Currently Running RMAN Backup "
  echo " "
  echo "10. Backup Snapshot Management Operations "
  echo " "
  echo "[Q] Return to the Main Menu "
  echo " "
  echo "-----------------------------------------------------------------------"
  echo -n " Enter your selection : "
  read select

    case ${select} in
#      1) if [ -f "${SHELLDIR}/Manual_RMAN_Full.sh" ]
#          then
#                echo -n " Please enter [y] to continue full backup : "
#                read input
#                input=`echo $input | tr '[a-z]' '[A-Z]'`
#                if [ "$input" = Y ]
#                then
#                        nohup ${SHELLDIR}/Manual_RMAN_Full.sh 1>/dev/null 2>&1 &
#                else
#                        echo " Operation canceled."
#                fi
#        else
#                echo "The backup script file doesn't exist."
#                echo "Please check the location of the script file."
#
#        fi
#        ;;

      1) if [ -f "${SHELLDIR}/Manual_RMAN_Level0.sh" ]
        then
                echo -n " Please enter [y] to continue Level0 backup : "
                read input
                input=`echo $input | tr '[a-z]' '[A-Z]'`
                if [ "$input" = Y ]
                then
                        nohup ${SHELLDIR}/Manual_RMAN_Level0.sh 1>/dev/null 2>&1 &
                else
                        echo " Input was canceled"
                fi
        else
                echo "The backup script doesn't exist."
                echo "Please check script file location."

        fi
        ;;

      2) if [ -f "${SHELLDIR}/Manual_RMAN_Level1.sh" ]
        then
                echo -n " Please enter [y] to continue Level1 backup : "
                read input
                input=`echo $input | tr '[a-z]' '[A-Z]'`
                if [ "$input" = Y ]
                then
                        nohup ${SHELLDIR}/Manual_RMAN_Level1.sh 1>/dev/null 2>&1 &

                else
                        echo " Input was canceled"
                fi
        else
                echo "The backup script doesn't exist."
                echo "Please check script file location."

        fi
        ;;

      3) if [ -f "${SHELLDIR}/Manual_RMAN_Merge.sh" ]
        then
                echo -n " Please enter [y] to continue RMAN Merge Job : "
                read input
                input=`echo $input | tr '[a-z]' '[A-Z]'`
                if [ "$input" = Y ]
                then
                        nohup ${SHELLDIR}/Manual_RMAN_Merge.sh 1>/dev/null 2>&1 &

                else
                        echo " Input was canceled"
                fi
        else
                echo "The backup script doesn't exist."
                echo "Please check script file location."

        fi
        ;;

      4) if [ -f "${SHELLDIR}/Manual_RMAN_Archivelog.sh" ]
        then
                echo -n " Please enter [y] to continue Archive Log backup : "
                read input
                input=`echo $input | tr '[a-z]' '[A-Z]'`
                if [ "$input" = Y ]
                then
                        nohup ${SHELLDIR}/Manual_RMAN_Archivelog.sh 1>/dev/null 2>&1 &

                else
                        echo " Input was canceled"
                fi
        else
                echo "The backup script file doesn't exist."
                echo "Please check the location of the script file."

        fi
        ;;

      5) ${SHELL} ${SHELLDIR}/PROD_rman_history.sh ;;

      6) ${SHELL} ${SHELLDIR}/run_showsnap.sh ;;

      7) ${SHELL} ${SHELLDIR}/list_backup_progress.sh ${DB_DIR}
         ${SHELL} ${SQLDIR}/backup_detail.sh
         ${SHELL} ${SHELLDIR}/datafile_backupcount.sh ${DB_DIR} ;;

      8) ${SHELL} ${SHELLDIR}/check_datafile_history.sh ;;

      9) if [ -f "${SHELLDIR}/cancel_backup.sh" ]
        then
                echo -n " Please enter [y] to Cancel : "
                read input
                input=`echo $input | tr '[a-z]' '[A-Z]'`
                if [ "$input" = Y ]
                then
                        nohup ${SHELLDIR}/cancel_backup.sh ${DB_DIR}  1>/dev/null 2>&1 &

                else
                        echo " Input was canceled"
                fi
        else
                echo "The backup script file doesn't exist."
                echo "Please check the location of the script file."

        fi
        ;;

      10) ${SHELL} ${ZFSDIR}/Menu_Operation.sh ;;
      q) exit
         ;;
        esac
                echo -n " Enter return to continue : [Return]"
        read input
done

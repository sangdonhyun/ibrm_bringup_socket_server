#!/bin/sh

. ${CLONEDB_DIR}/CloneDB_Profile
while true
do
  clear
  echo "=========================================================================="
  echo " [${ORACLE_SID}] Bring-up Steps !!!"
  echo "=========================================================================="
  echo "   1.  Create Control file for CloneDB Bring-up "
  echo " "
  echo "   2.  Read Catalog Information from backup data"
  echo " "
  echo "   3.  Create Trace Control file and list datafile informations"
  echo " "
  echo "   4.  Execute SCN Based Recovery "
  echo " "
  echo "   5.  Execute Sequence Based Recovery "
  echo " "
  echo "   6.  Execute Time Based Recovery "
  echo " "
  echo "   Enter [q] - Return to the Previous Menu "
  echo "--------------------------------------------------------------------------"
  echo " "
  echo -n "Enter your selection : "
    read answer

      case ${answer} in

       1) nohup ${DBADIR}/1.Create_Controlfile.sh 1>/dev/null 2>&1 ;;
       2) nohup ${DBADIR}/2.Backup_Catalog.sh 1>/dev/null 2>&1 ;;
       3) nohup ${DBADIR}/3.Trace_Controlfile.sh 1>/dev/null 2>&1 ;;
       4) echo "See below for the SCN number at the time of backup completion! "
	  cat ${CLONE_ARCH_DIR1}/2.SCN_number.txt
	  echo "--------------------------------------------------"
	  echo -n "Input SCN you want to recover :"
	  read SCN
               echo -n "Press [y] to start SCN based recovery : "
              	read input
                input=`echo $input | tr '[a-z]' '[A-Z]'`
                if [ "$input" = Y ]
                   then
   		      ${SHELL} ${DBADIR}/4.RecoverSCN.sh $SCN 1>/dev/null 2>&1 & 
               	   else
                      echo "Input was canceled"
                fi
           ;;

       5) echo ""
	  echo "-----------------------------------------------------------"
	  echo -n "Input Sequence Number you want to recover : "
	  read SQN
               echo -n "Press [y] to start Sequence based recovery : "
              	read input
                input=`echo $input | tr '[a-z]' '[A-Z]'`
                if [ "$input" = Y ]
                   then
   		      ${SHELL} ${DBADIR}/5.RecoverSequence.sh $SQN 1>/dev/null 2>&1 & 
               	   else
                      echo "Input was canceled"
                fi
           ;;

       6) echo ""
          echo "Sample Input Format : 2020/02/24 12:30:30" 
	  echo "---------------------------------------------------------------"
	  echo -n "Input date and time you want to recover : "
	  read TIME
               echo -n "Press [y] to start Time based recovery : "
              	read input
                input=`echo $input | tr '[a-z]' '[A-Z]'`
                if [ "$input" = Y ]
                   then
   		      ${SHELL} ${DBADIR}/6.RecoverTIME.sh $TIME 1>/dev/null 2>&1 & 
               	   else
                      echo "Input was canceled"
                fi
           ;;

       q) exit 
         ;;
        esac
              echo -n "Press Enter to continue : [Return]"
        read input
done

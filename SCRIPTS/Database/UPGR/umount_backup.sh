clear
echo ""
echo "***********************************************************************************************"
echo "Filesystem                  Type     Size Used  Avail Use% Mounted on                "
echo "-----------------------------------------------------------------------------------------------"
df -PhT |grep ${DB_DIR} |sort -k1
echo "***********************************************************************************************"
echo "CAUTION!!! Apply this DB environments variable ZFS_Profile first before executing this command." 
echo "Umount command need root privileges.							     "		
echo "Please input root password !!!								     "
su - root -c " ${BASEDIR}/SCRIPTS/SHELL/umount_backup.sh  $DB_DIR "

echo "***********************************************************************************************"
echo "Filesystem                  Type     Size Used  Avail Use% Mounted on                "
echo "-----------------------------------------------------------------------------------------------"
df -PhT |grep ${DB_DIR} |sort -k1
echo "***********************************************************************************************"

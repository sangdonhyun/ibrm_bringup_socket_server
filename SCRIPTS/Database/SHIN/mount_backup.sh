clear
echo ""
echo "***********************************************************************************************"
echo "CAUTION!!! Apply this DB environments variable ZFS_Profile first before executing this command." 
echo "Mount command need root privileges.                      					     "
echo "Please input root password !!!							  	     "
su - root -c " ${BASEDIR}/SCRIPTS/SHELL/mount_backup.sh $DB_DIR 				     "

echo "***********************************************************************************************"
echo "Filesystem                  Type     Size Used  Avail Use% Mounted on                "
echo "-----------------------------------------------------------------------------------------------"
df -PhT |grep ${DB_DIR} |sort -k7
echo "***********************************************************************************************"

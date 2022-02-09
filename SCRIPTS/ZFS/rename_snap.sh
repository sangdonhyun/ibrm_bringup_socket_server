#!/bin/sh

if [ $# -lt 6 ]
then
        echo "Usage: $0 <login string: user@nashead> <poolName> <projName> <shareName> <snapName_from>  <snapName_to>"
        exit 1
fi


LOGINSTRING=$1
POOLNAME=$2
PROJNAME=$3
SHARENAME=$4
SNAPNAME_F=$5
SNAPNAME_T=$6


ssh -T $LOGINSTRING << EOF
script
{
        var shareName='$SHARENAME';
        var poolName='$POOLNAME';
        var projName='$PROJNAME';
        var snapName='$SNAPNAME';
        var snapName_from='$SNAPNAME_F';
        var snapName_to='$SNAPNAME_T';


        printf( "Renaming snapshot from %s to %s in the  %s of share %s in project %s on pool %s\n", snapName_from, snapName_to, snapName, shareName, projName, poolName);
        run ('cd /');
        run ('shares');
        run ('set pool=' + poolName );
        run ('select ' + projName);
        run ('select ' + shareName);
        run ('snapshots rename ' + snapName_from + ' ' +snapName_to );
        run ('commit');
        printf("snapshot renaming is completed..\n\n");
        exit( 0 );
}
EOF

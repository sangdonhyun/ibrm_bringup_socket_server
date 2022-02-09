#!/bin/sh

if [ $# -lt 5 ]
then
        echo "Usage: $0 <login string: user@nashead> <poolName> <projName> <snapName> <shareName> "
        exit 1
fi


LOGINSTRING=$1
POOLNAME=$2
PROJNAME=$3
SNAPNAME=$4
SHARENAME=$5


ssh -T $LOGINSTRING << EOF
script
{
        var projName='$PROJNAME';
        var snapName='$SNAPNAME';
        var poolName='$POOLNAME';
        var shareName='$SHARENAME';


        printf( "Delete snapshot %s of project %s on pool %s\n", snapName, projName, poolName);
        run ('cd /');
        run ('shares');
        run ('set pool=' + poolName);
        run ('select ' + projName);
        run ('select ' + shareName);
        run ('snapshots');
        run ('confirm destroy ' + snapName);
        printf("snapshot deleted..\n\n");
        exit( 0 );
}
EOF

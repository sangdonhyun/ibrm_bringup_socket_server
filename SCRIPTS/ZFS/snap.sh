#!/bin/sh

if [ $# -lt 5 ]
then
        echo "Usage: $0 <login string: user@nashead> <poolName> <projName> <shareName> <snapName> "
        exit 1
fi


LOGINSTRING=$1
POOLNAME=$2
PROJNAME=$3
SHARENAME=$4
SNAPNAME=$5


ssh -T $LOGINSTRING << EOF
script
{
        var projName='$PROJNAME';
        var snapName='$SNAPNAME';
        var shareName='$SHARENAME';
        var poolName='$POOLNAME';


        printf( "Creating snapshot %s of share %s in project %s on pool %s\n", snapName, shareName, projName, poolName);
        run ('cd /');
        run ('shares');
        run ('set pool=' + poolName );
        run ('select ' + projName);
        run ('select ' + shareName);
        run ('snapshots snapshot ' + snapName);
        run ('commit');
        printf("snapshot the project completed..\n\n");
        exit( 0 );
}
EOF


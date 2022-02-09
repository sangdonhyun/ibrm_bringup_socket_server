#!/bin/sh

if [ $# -lt 5 ]
then
        echo "Usage: $0 <login string: user@nashead> <poolName> <projName> <shareName> <RollbackSnap> "
        exit 1
fi


LOGINSTRING=$1
POOLNAME=$2
PROJNAME=$3
SHARENAME=$4
ROLLBACKSNAP=$5


ssh -T $LOGINSTRING << EOF
script
{
        var poolName='$POOLNAME';
        var projName='$PROJNAME';
        var shareName='$SHARENAME';
        var RollbackSnap='$ROLLBACKSNAP';


        printf( "Rollback snapshot %s of share %s in project %s on pool %s\n", RollbackSnap, shareName, projName, poolName);
        run ('cd /');
        run ('shares');
        run ('set pool=' + poolName );
        run ('select ' + projName);
        run ('select ' + shareName);
        run ('snapshots');
        run ('select ' + RollbackSnap);
        run ('confirm rollback');
        run ('commit');
        printf("Data return to %s.\n\n", RollbackSnap);
        exit( 0 );
}
EOF


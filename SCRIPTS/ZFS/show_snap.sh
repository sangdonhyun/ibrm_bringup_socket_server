#!/bin/sh

if [ $# -lt 4 ]
then
        echo "Usage: $0 <login string: user@nashead> <poolName> <projName> <shareName>" 
        exit 1
fi


LOGINSTRING=$1
POOLNAME=$2
PROJNAME=$3
SHARENAME=$4


ssh -T $LOGINSTRING << EOF
script
{
        var projName='$PROJNAME';
        var poolName='$POOLNAME';
        var shareName='$SHARENAME';

        run ('cd /');
	run ('shares');
        run ('set pool=' + poolName);
        run ('select ' + projName);
        run ('select ' + shareName);
        run ('snapshots');
        run ('show');
        var snapList = list() ;
        for (var i=0; i<snapList.length; i++)
        {
                printf (" %s\n", snapList[i]);
        }

        exit( 0 );
}
EOF


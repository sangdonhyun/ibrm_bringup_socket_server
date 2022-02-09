#!/bin/sh

if [ $# -lt 3 ]
then
        echo "Usage: $0 <login string: user@nashead> <poolName> <projName> " 
        exit 1
fi


LOGINSTRING=$1
POOLNAME=$2
PROJNAME=$3


ssh -T $LOGINSTRING << EOF
script
{
        var projName='$PROJNAME';
        var poolName='$POOLNAME';

        run ('cd /');
	run ('shares');
        run ('set pool=' + poolName);
        run ('select ' + projName);
        run ('list');
        var fsList = list() ;
        for (var i=0; i<fsList.length; i++)
        {
                printf (" %s \n", fsList[i] );
        }

        exit( 0 );
}
EOF


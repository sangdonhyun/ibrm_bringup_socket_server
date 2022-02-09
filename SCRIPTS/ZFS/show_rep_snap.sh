#!/bin/sh

if [ $# -lt 4 ]
then
        echo "Usage: $0 <login string: user@nashead> <sourceName> <packageName> <projName> <shareName> "
        exit 1
fi


LOGINSTRING=$1
SOURCENAME=$2
PACKAGENAME=$3
PROJNAME=$4
SHARENAME=$5


ssh -T $LOGINSTRING << EOF
script
{
        var sourceName='$SOURCENAME';
        var packageName='$PACKAGENAME';
        var projName='$PROJNAME';
        var shareName='$SHARENAME';

	run('shares replication sources');
	run('select ' + sourceName);
	run('select ' + packageName);
	run('select ' + projName);
	run('select ' + shareName);
        run('snapshots');
	run('list');
        var snapList = list() ;
        for (var i=0; i<snapList.length; i++)
        {
                printf (" %s\n", snapList[i]);
        }

        exit( 0 );

}
EOF

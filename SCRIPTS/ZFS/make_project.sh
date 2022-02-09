#!/bin/sh

if [ $# -lt 1 ]
then
        echo "Usage: $0 <login string: <root@nashead> <nprojName> "
        exit 1
fi


LOGINSTRING=$1
NPROJNAME=$2


ssh -T $LOGINSTRING << EOF
script
{
        var nprojName='$NPROJNAME';

	run('cd /');
	run('shares');
	run('project ' + nprojName);
	run('commit');
        printf("Create a new Project %s for replicated snapshot has been completed..\n\n", nprojName);
        exit( 0 );

}
EOF

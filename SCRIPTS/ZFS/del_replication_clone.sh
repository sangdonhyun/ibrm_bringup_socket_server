#!/bin/sh

if [ $# -lt 3 ]
then
        echo "Usage: $0 <login string: user@nashead> <poolName> <projName> "
        exit 1
fi


LOGINSTRING=$1
POOLNAME=$2
PROJNAME=$3


if [ $# -eq 3 ]
then
        SHARENFSSTRING=on
else
        shift 5
        SHARENFSSTRING=""
        while [ $# -gt 0 ]
do
        if [ ${SHARENFSSTRING}x = "x" ]
        then
                SHARENFSSTRING=rw,root=@$1
        else
                SHARENFSSTRING=$SHARENFSSTRING:rw,root=@$1
        fi
        shift 1
done
fi


ssh -T $LOGINSTRING << EOF
script
{
        var poolName='$POOLNAME';
        var projName='$PROJNAME';
        var shareName='$SHARENAME';

        printf( "Deleting Clone Share of %s project %s on pool %s.\n",shareName,projName,poolName);
        try
        {
                run( 'cd /' );
                run( 'shares' );
                run ( 'set pool=' + poolName ) ;
                run( 'confirm destroy' + projName );
        }
        catch (err)
        {
                printf( "Error deleting replicated clone project %s in pool %s\n",projName,poolName);
                exit( 1 );
        }

        printf( "Deleting replicated clone project  %s in pool %s completed.\n",projName,poolName);
        exit( 0 );
}
EOF

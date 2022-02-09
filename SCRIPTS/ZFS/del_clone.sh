#!/bin/sh

if [ $# -lt 3 ]
then
        echo "Usage: $0 <login string: user@nashead> <poolName> <projName> <shareName> [root access ip address list: xxx.xxx.xxx.xxx/yy xxx.xxx.xxx.xxx/yyy ...]"
        exit 1
fi


LOGINSTRING=$1
POOLNAME=$2
PROJNAME=$3
SHARENAME=$4


if [ $# -eq 4 ]
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
                run( 'select ' + projName );
                run( 'select ' + shareName);

                printf( "Deleting Clone Share %s \n", shareName );

                run( 'confirm destroy' );
                run( 'commit' ) ;
                run( 'cd ../../..' );
        }
        catch (err)
        {
                printf( "Error deleting clone shares in project %s in pool %s\n",projName,poolName);
                exit( 1 );
        }

        printf( "Deleting Clone of shares %s as project %s on pool %s completed.\n",shareName,projName,poolName);
        exit( 0 );
}
EOF

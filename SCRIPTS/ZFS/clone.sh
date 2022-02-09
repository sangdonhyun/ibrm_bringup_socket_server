#!/bin/sh

if [ $# -lt 5 ]
then
        echo "Usage: $0 <login string: user@nashead> <poolName> <projName> <snapName> <cloneName> [root access ip address list: xxx.xxx.xxx.xxx/yy xxx.xxx.xxx.xxx/yyy ...]"
        exit 1
fi


LOGINSTRING=$1
POOLNAME=$2
PROJNAME=$3
SHARENAME=$4
SNAPNAME=$5
CLONENAME=$6


if [ $# -eq 6 ]
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
        var projName='$PROJNAME';
        var cloneName='$CLONENAME';
        var shareName='$SHARENAME';
        var snapName='$SNAPNAME';
        var poolName='$POOLNAME';

        printf( "Cloning of %s using snapshot %s, project %s on pool %s.\n",shareName,snapName,projName,poolName);
        try
        {
                run( 'cd /' );
                run( 'shares' );
                run ( 'set pool=' + poolName ) ;
                run( 'select ' + projName );

                run( 'select ' + shareName);
                run( 'snapshots' );
                run( 'select ' + snapName );

                printf( "Cloning the share %s \n", shareName );

                run( 'clone ' + projName + ' ' + cloneName );
                run( 'set mountpoint=/export/' + cloneName );
                run( 'commit' ) ;
                run( 'cd ../../..' );
        }
        catch (err)
        {
                printf( "Error cloning shares in project %s in pool %s\n",projName,poolName);
                exit( 1 );
        }

        printf( "Cloning of shares %s as project %s on pool %s completed.\n",cloneName,projName,poolName);
        exit( 0 );
}
EOF

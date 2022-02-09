#!/bin/sh


LOGINSTRING=$1

ssh -T $LOGINSTRING << EOF
script
{

        printf( " List Support Bundle!!! \n\n" );
        run ('cd /');
        run ('maintenance');
        run ('system');
        bundles = list();

        for (var i=0; i<bundles.length; i++)
        {
           SRList = run('bundles' +list).split(/\s+/)[1];
            for (var j=0; j<SRList.length; j++)
                printf (" %-40s %s \n", bundles[i], SRList );
        }

        exit( 0 );
}
EOF

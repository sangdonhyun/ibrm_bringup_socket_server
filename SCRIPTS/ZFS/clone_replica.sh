#if [ $# -lt 7 ]
#then
#        echo "Usage: $0 <login string: <root@nashead> <sourceName> <packageName> <sprojName> <sdataName> <snapName> <nprojName> <sharecloneData> "
#        exit 1
#fi

LOGINSTRING=$1
SOURCENAME=$2
PACKAGENAME=$3
SPROJNAME=$4
SDATANAME=$5
SNAPNAME=$6
NPROJNAME=$7
CLONEDATA=$8


ssh -T $LOGINSTRING << EOF
script
{
        var sourceName='$SOURCENAME';
        var packageName='$PACKAGENAME';
        var sprojName='$SPROJNAME';
        var sdataName='$SDATANAME';
        var snapName='$SNAPNAME';
        var nprojName='$NPROJNAME';
        var scloneData='$CLONEDATA';

        printf("Creating Clone Image from the replicated project %s \n", sprojName);
        {
		run('shares replication sources');
		run('select ' + sourceName);
		run('select ' + packageName);
		run('select ' + sprojName);
		run('select ' + sdataName);

		run('snapshots');
		run('select ' + snapName);
		run('clone ' + nprojName + ' ' + scloneData);
		run('commit');
        }
        printf("Create Clone Image from replicated snapshot as new project  %s has been completed..\n\n", nprojName);
        exit( 0 );

}
EOF

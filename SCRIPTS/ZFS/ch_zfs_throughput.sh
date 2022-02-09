if [ $# -lt 4 ]
then
echo "Usage: $0 <login string: user@nashead> <poolName> <projName> <shareName> "
      exit 1
fi

LOGINSTRING=$1
echo $LOGINSTRING
POOLNAME=$2
PROJNAME=$3
SHARENAME=$4

ssh -T $LOGINSTRING << EOF

script
{
    var poolName='$POOLNAME';
    var projName='$PROJNAME';
    var ShareName='$SHARENAME';
     run('cd /');
     run('shares');
     run('set pool=' + poolName);
     run('select ' + projName);
     run('select ' + ShareName);
     run('set logbias=throughput');
     run('commit');
     run('cd ..');
     run('cd ..');
     run('cd ..');

     printf(" $SHARENAME has been changed to throughput mode!!! \n");
}
EOF

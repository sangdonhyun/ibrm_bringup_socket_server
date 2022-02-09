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
       run('shares');
       projects = list();

       printf('%-40s %-10s %-10s\n', 'SHARE', 'USED', 'AVAILABLE');

       for (i = 0; i < projects.length; i++) {
               run('select ' + projects[i]);
               shares = list();

               for (j = 0; j < shares.length; j++) {
                       run('select ' + shares[j]);

                       share = projects[i] + '/' + shares[j];
                       used = run('get space_data').split(/\s+/)[3];
                       avail = run('get space_available').split(/\s+/)[3];

                       printf('%-40s %-10s %-10s\n', share, used, avail);
                       run('cd ..');
               }

               run('cd ..');
       }
EOF

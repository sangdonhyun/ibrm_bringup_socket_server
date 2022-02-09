import os

dir_list = list()
ret = os.popen('df -k | grep /ZFS').read()
for line in ret.splitlines():
    dir=line.split()[-1]
    cmd = "du {}".format(dir)
    sub_dirs = os.popen(cmd).read()
    for sub_line in sub_dirs.splitlines():
        if not sub_line.split()[-1] == dir:
            dir_list.append(sub_line.split()[-1])

for dir in dir_list:
    print(dir)
    if 'ARCH' in dir:
        cmd = 'rm -rf {}'.format(dir)
    else:
        cmd = 'rm -rf {}/*'.format(dir)
    print(cmd)
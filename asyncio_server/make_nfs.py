class nfs():
    def __init__(self):
        pass

    def make_fstab(self,nfs_name):
        """
        ## NFS File systems for CloneDB_
          ZFS_VM:/export/CLONE_BAK_ORCL_11    /ZFS/CLONEDB1/DATA_ORCL_11     nfs     noauto,user,rw,hard,rsize=32768,wsize=32768,tcp,nfsvers=4,timeo=600 0 0
          ZFS_VM:/export/CLONE_BAK_ORCL_12    /ZFS/CLONEDB1/DATA_ORCL_12     nfs     noauto,user,rw,hard,rsize=32768,wsize=32768,tcp,nfsvers=4,timeo=600 0 0
          ZFS_VM:/export/CLONE_ARC_ORCL_11    /ZFS/CLONEDB1/ARCH_ORCL_11     nfs     noauto,user,rw,hard,rsize=32768,wsize=32768,tcp,nfsvers=4,timeo=600 0 0
          ZFS_VM:/export/CLONE_ARC_ORCL_12    /ZFS/CLONEDB1/ARCH_ORCL_12     nfs     noauto,user,rw,hard,rsize=32768,wsize=32768,tcp,nfsvers=4,timeo=600 0 0

        :return:
        """
        fs_tab = '/etc/fstab'
        with open(fs_tab) as f:
            lines = f.readlines()
        make_bit = True
        for line in lines:
            print(line)
            if 'nfs_name' in line:
                make_bit = False
        if make_bit:
            cmd = """echo "ZFS_VM:/export/CLONE_BAK_ORCL_11    /ZFS/CLONEDB1/DATA_ORCL_11     nfs     noauto,user,rw,hard,rsize=32768,wsize=32768,tcp,nfsvers=4,timeo=600 0 0
          ZFS_VM:/export/CLONE_BAK_ORCL_12    /ZFS/CLONEDB1/DATA_ORCL_12     nfs     noauto,user,rw,hard,rsize=32768,wsize=32768,tcp,nfsvers=4,timeo=600 0 0
          ZFS_VM:/export/CLONE_ARC_ORCL_11    /ZFS/CLONEDB1/ARCH_ORCL_11     nfs     noauto,user,rw,hard,rsize=32768,wsize=32768,tcp,nfsvers=4,timeo=600 0 0
          ZFS_VM:/export/CLONE_ARC_ORCL_12    /ZFS/CLONEDB1/ARCH_ORCL_12     nfs     noauto,user,rw,hard,rsize=32768,wsize=32768,tcp,nfsvers=4,timeo=600 0 0" 
            """


    def mount_nfs(self):
        pass
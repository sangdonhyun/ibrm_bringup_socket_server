import os
import fbrm_dbms
import zfs_conn
import datetime

class zfs_fs_del():
    def __init__(self, zfs_info):
        self.zfs_info = zfs_info
        self.zfs_conn = zfs_conn.zfs_pools(zfs_info)
        self.pools_href_list = self.get_pools_href_list()
        self.set_prj_list = list()
        self.set_fs_list = list()
        self.set_snapshot_list = list()
        self.fs_href_list = list()
        self.prj_href_list = list()

    def get_filesystems(self):
        print('#' * 50)
        print('FILE SYSTEM')
        print('#' * 50)
        print (self.prj_href_list)
        for href in self.prj_href_list:
            # print href
            url = href + '/filesystems'
            full_url = self.zfs_conn.get_url(url)
            print (full_url)
            fs_json = self.zfs_conn.get_request(full_url)
            # print (self.zfs_conn.json_to_str(fs_json))
            for fs in list(fs_json['filesystems']):
                self.set_fs_list.append(fs)
                href = fs['href']
                self.fs_href_list.append(href)
        return self.set_fs_list

    def get_pools_href_list(self):
        url = 'api/storage/v1/pools'
        full_url = self.zfs_conn.get_url(url)
        root = self.zfs_conn.get_request(full_url)
        print(root)
        pool_href_list=[]
        for pool in list(root['pools']):
            if 'href' in list(pool.keys()):
                pool_href_list.append(pool['href'])
            self.zfs_conn.json_to_str(pool)
        return pool_href_list

    def get_projects(self):
        print('#' * 50)
        print('PROJECTS')
        print('#' * 50)

        # print self.pools_href_list
        for href in self.pools_href_list:
            url = href + '/projects'
            # print project_cmd
            full_url = self.zfs_conn.get_url(url)
            projects_json = self.zfs_conn.get_request(full_url)
            if 'projects' in list(projects_json.keys()):
                for prj in projects_json['projects']:
                    self.set_prj_list.append(prj)
                    href = prj['href']
                    print (href)
                    self.prj_href_list.append(href)



    def main(self):
        self.get_projects()
        self.get_filesystems()
        del_fs_list=list()
        for href in self.fs_href_list:
            print(href)
            if 'CLONE_' in href:
                del_fs_list.append(href)
        for url in del_fs_list:
            self.zfs_conn.del_fs(url)
        self.fs_href_list = list()
        self.get_filesystems()
        for href in self.fs_href_list:
            print(href)



if __name__=='__main__':
    zfs_info = dict()
    zfs_info['zfs_name'] = 'ZFS-88'
    zfs_info['ip'] = '121.170.193.213'
    zfs_info['user'] = 'root'
    zfs_info['passwd'] = 'welcome1'
    zfs_info['port'] = '215'
    zfs_fs_del(zfs_info).main()
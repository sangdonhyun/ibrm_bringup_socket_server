import os
import fbrm_dbms
import zfs_conn
import datetime
import json
import configparser

class zfs_snaphosts():
    def __init__(self,zfs_info):
        self.zfs_info = zfs_info
        self.db = fbrm_dbms.fbrm_db()
        self.zfs_conn = zfs_conn.zfs_pools(zfs_info)
        self.pools_href_list = self.get_pools_href_list()
        self.set_prj_list = list()
        self.set_fs_list = list()
        self.set_snapshot_list = list()
        self.fs_href_list = list()
        self.prj_href_list = list()
        self.asn = self.zfs_conn.asn
        self.cluster_name = self.zfs_conn.cluster_name
        self.fbrm_date = datetime.datetime.now().strftime('%Y-%m-%d')
        self.ins_datetime = datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S')

    def check_live_zfs_projects_colume(self):
        return ["aclinherit","aclmode","atime","canonical_name","checksum","compression","copies","creation","dedup","defaultuserquota","defaultgroupquota","encryption","exported","keychangedate","keystatus","id","logbias","maxblocksize","migration","mountpoint","nbmand","nodestroy","pool","quota","readlimit","readonly","recordsize","reservation","rstchown","secondarycache","sharedav","shareftp","sharenfs","sharesftp","sharesmb","shareobjectstore","sharetftp","snapdir","snaplabel","vscan","writelimit","space_available","space_data","space_unused_res","space_snapshots","space_total","space_unused_res_shares","compressratio","default_group","default_permissions","default_sparse","default_user","default_volblocksize","default_volsize","name","defaultreadlimit","defaultwritelimit","href","zfs_name","node_name","asn","zfs_ip","cluster_ip","fbrm_date","ins_date_time","cluster_name"]

    def check_store_day_zfs_projects_colume(self):
        return ["aclinherit","aclmode","atime","canonical_name","checksum","compression","copies","creation","dedup","defaultuserquota","defaultgroupquota","encryption","exported","keychangedate","keystatus","id","logbias","maxblocksize","migration","mountpoint","nbmand","nodestroy","pool","quota","readlimit","readonly","recordsize","reservation","rstchown","secondarycache","sharedav","shareftp","sharenfs","sharesftp","sharesmb","shareobjectstore","sharetftp","snapdir","snaplabel","vscan","writelimit","space_available","space_data","space_unused_res","space_snapshots","space_total","space_unused_res_shares","compressratio","default_group","default_permissions","default_sparse","default_user","default_volblocksize","default_volsize","name","defaultreadlimit","defaultwritelimit","href","zfs_name","node_name","asn","zfs_ip","cluster_ip","fbrm_date","ins_date_time","cluster_name"]

    def check_live_zfs_filesystems_colume(self):
        return ["aclinherit","aclmode","atime","canonical_name","checksum","compression","copies","creation","dedup","effectivereadlimit","effectivewritelimit","encryption","exported","keychangedate","keystatus","id","logbias","maxblocksize","migration","mountpoint","nbmand","nodestroy","pool","quota","readlimit","readonly","reservation","rstchown","secondarycache","sharedav","shareftp","sharenfs","sharesftp","sharesmb","shareobjectstore","sharetftp","snapdir","snaplabel","vscan","writelimit","space_available","space_data","space_total","space_unused_res_shares","compressratio","casesensitivity","normalization","root_group","name","root_permissions","project","quota_snap","reservation_snap","shadow","root_user","utf8only","href","zfs_name","node_name","zfs_ip","asn","fbrm_date","ins_date_time","cluster_name"]

    def check_store_zfs_filesystems_colume(self):
        return ["aclinherit","aclmode","atime","canonical_name","checksum","compression","copies","creation","dedup","effectivereadlimit","effectivewritelimit","encryption","exported","keychangedate","keystatus","id","logbias","maxblocksize","migration","mountpoint","nbmand","nodestroy","pool","quota","readlimit","readonly","reservation","rstchown","secondarycache","sharedav","shareftp","sharenfs","sharesftp","sharesmb","shareobjectstore","sharetftp","snapdir","snaplabel","vscan","writelimit","space_available","space_data","space_total","space_unused_res_shares","compressratio","casesensitivity","normalization","root_group","name","root_permissions","project","quota_snap","reservation_snap","shadow","root_user","utf8only","href","zfs_name","node_name","zfs_ip","asn","fbrm_date","ins_date_time","cluster_name","store_date","write_date"]

    def check_live_zfs_snapshots_colume(self):
        return ["canonical_name","collection","creation","numclones","isauto","shadowsnap","id","pool","project","share","name","type","space_data","space_unique","href","zfs_name","node_name","zfs_ip","fbrm_date","ins_date_time","asn","cluster_name"]

    def check_colume_key(self, dict_list,tbname ):
        if tbname == 'live.live_zfs_projects':
            args = self.check_live_zfs_projects_colume()
        elif tbname == 'store.store_day_zfs_projects':
            args = self.check_store_day_zfs_projects_colume()
        elif tbname == 'live.live_zfs_filesystems':
            args = self.check_live_zfs_filesystems_colume()
        elif tbname == 'store.store_day_zfs_filesystems':
            args = self.check_store_zfs_filesystems_colume()
        elif tbname == 'live.live_zfs_snapshots':
            args = self.check_live_zfs_snapshots_colume()
        print(tbname)
        print (args)
        for arg_dict in dict_list:
            keys = list(arg_dict.keys())
            for key in keys:
                if key not in args:
                    del arg_dict[key]
        return dict_list

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
        prj_list=[]
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
                    prj_list.append(prj['name'])
                    # print (href)
                    prj=href.split('/')[-1]
                    if prj in ('ORCL','ORA19'):
                        self.prj_href_list.append(href)
        return prj_list

    def set_projects(self):
        print('projects count :', len(self.set_prj_list))
        prj_dict_list = []
        query = """select node_name,cluster_name from master.master_zfs_cluster  where asn='{}' """.format(self.asn)
        # print query
        ret = self.db.getRaw(query)
        # print ret
        if len(ret) > 0:
            zfs_name = ret[0][0]
            cluster_name = ret[0][1]
        else:
            zfs_name = self.zfs_info['zfs_name']
            cluster_name = self.zfs_info['zfs_name']
        # self.i_cluster_name, self.cluster_name = zfs_name, cluster_name
        for prj in self.set_prj_list:
            # print(prj)
            prj_dict = dict()
            del prj['source']
            prj['zfs_name'] = zfs_name
            prj['node_name'] = self.zfs_info['zfs_name']
            prj['asn'] = self.zfs_conn.asn
            prj['zfs_ip'] = self.zfs_info['ip']
            prj['cluster_ip'] = self.zfs_info['ip']
            prj['space_data'] = str(round(float(prj['space_data'])))
            prj['space_total'] = str(round(float(prj['space_total'])))
            prj['space_available'] = str(round(float(prj['space_available'])))
            prj['space_snapshots'] = str(round(float(prj['space_snapshots'])))
            prj['space_unused_res_shares'] = str(round(float(prj['space_unused_res_shares'])))

            prj['fbrm_date'] = self.fbrm_date
            prj['ins_date_time'] = datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S')
            create_str = prj['creation']
            "20200319T06:47:06"
            create_date = datetime.datetime.strptime(create_str, "%Y%m%dT%H:%M:%S").strftime('%Y-%m-%d %H:%M:%S')
            prj['creation'] = create_date
            prj['cluster_name'] = self.cluster_name
            prj_dict_list.append(prj)
            if 'shares3' in prj.keys():
                del(prj['shares3'])
            if 'shareoci' in prj.keys():
                del(prj['shareoci'])

        tb = 'live.live_zfs_projects'
        query = "delete from {} where asn ='{}'".format(tb, self.asn)
        self.db.queryExec(query)
        self.check_colume_key(prj_dict_list, tb)
        self.db.dbInsertList(prj_dict_list, tb)
        store_prj_dict_list = self.set_store_list(prj_dict_list)
        tb = 'store.store_day_zfs_projects'
        self.check_colume_key(store_prj_dict_list, tb)
        self.db.dbInsertList(store_prj_dict_list, tb)


    def set_store_list(self, live_list):
        store_list = []
        for item in live_list:
            item['store_date'] = item['fbrm_date']
            item['write_date'] = item['ins_date_time']
            store_list.append(item)
        return store_list

    def get_filesystems(self):
        print('#' * 50)
        print('FILE SYSTEM')
        print('#' * 50)
        print (self.prj_href_list)

        for href in self.prj_href_list:
            # print href
            url = href + '/filesystems'
            full_url = self.zfs_conn.get_url(url)
            # print (full_url)
            fs_json = self.zfs_conn.get_request(full_url)
            # print (self.zfs_conn.json_to_str(fs_json))
            for fs in list(fs_json['filesystems']):
                self.set_fs_list.append(fs)
                href = fs['href']
                self.fs_href_list.append(href)
        return self.set_fs_list

    def set_filesystems(self):
        print('#' * 50)
        print('FILESYSTEMS SET ')
        print('#' * 50)
        print( len(self.set_fs_list))
        pool_fs_list = []
        for fs in self.set_fs_list:
            # print fs
            del fs['source']
            fs['zfs_name'] = self.zfs_info['zfs_name']
            fs['node_name'] = self.zfs_info['zfs_name']
            fs['zfs_ip'] = self.zfs_info['ip']
            fs['asn'] = self.asn

            fs['space_total'] = float(fs['space_total'])
            fs['space_available'] = float(fs['space_available'])
            fs['space_data'] = float(fs['space_data'])
            fs['space_snapshots'] = float(fs['space_snapshots'])
            fs['quota'] = float(fs['quota'])
            fs['maxblocksize'] = float(fs['maxblocksize'])
            fs['reservation'] = float(fs['reservation'])
            if 'recordsize' in fs.keys():
                del fs['recordsize']
            if 'space_snapshots' in fs.keys():
                del fs['space_snapshots']
            if 'shareoci' in fs.keys():
                del fs['shareoci']
            if 'shares3' in fs.keys():
                del fs['shares3']
            fs['space_unused_res'] = str(float(fs['space_unused_res']))
            if 'space_unused_res' in fs.keys():
                del fs['space_unused_res']

            fs['fbrm_date'] = self.fbrm_date
            fs['ins_date_time'] = self.ins_datetime
            fs['root_acl'] = str(fs['root_acl'])
            del fs['root_acl']
            create_str = fs['creation']
            "20200319T06:47:06"
            create_date = datetime.datetime.strptime(create_str, "%Y%m%dT%H:%M:%S").strftime('%Y-%m-%d %H:%M:%S')
            fs['creation'] = create_date
            fs['cluster_name'] = self.cluster_name
            if 'origin' in fs.keys():
                origin = fs['origin']
                fs['origin_project'] = origin['project']
                fs['origin_share'] = origin['share']
                fs['origin_snapshot'] = origin['snapshot']
                fs['origin_pool'] = origin['pool']
                fs['origin_collection'] = origin['collection']
                del fs['origin']
            # fs['root_acl'] = str("'{}'".format()['root_acl'])
            pool_fs_list.append(fs)
        # tb_name = 'zfs_filesystems_realtime'
        # tb_name_y = 'fbrm.' + tb_name + "_" + self.tb_c.to_day_y
        # self.tb_c.is_table_tb(tb_name)
        # self.db.dbInsertList(pool_fs_list,tb_name_y)
        tb = 'live.live_zfs_filesystems'
        query = "delete from {} where asn = '{}'".format(tb,self.asn)
        self.db.queryExec(query)
        self.check_colume_key(pool_fs_list,tb)
        self.db.dbInsertList(pool_fs_list, tb)
        store_fs_list = self.set_store_list(pool_fs_list)
        tb = 'store.store_day_zfs_filesystems'
        self.check_colume_key(pool_fs_list,tb)
        self.db.dbInsertList(store_fs_list, tb)

    def get_snapshots(self):
        print('#' * 50)
        print('SNAPSHOTS')
        print('#' * 50)
        snapshot_list=list()
        self.get_projects()
        self.get_filesystems()
        for href in self.fs_href_list:
            # print href
            url = href + '/snapshots'
            full_url = self.zfs_conn.get_url(url)
            root = self.zfs_conn.get_request(full_url)
            # print root['snapshots']
            for snap in list(root['snapshots']):
                if not snap['name'][0] == '.':
                    self.set_snapshot_list.append(snap)
        return self.set_snapshot_list

    def set_snapshots(self):
        print('#' * 50)
        print('SNAPSHOTS SET ')
        print('#' * 50)
        pool_snapshot_list = []
        for snapshot in self.set_snapshot_list:
            # print snapshot
            snapshot['space_data'] = str(int(snapshot['space_data']))
            snapshot['zfs_name'] = self.zfs_info['zfs_name']
            snapshot['node_name'] = self.zfs_info['zfs_name']
            snapshot['zfs_ip'] = self.zfs_info['ip']
            snapshot['fbrm_date'] = self.fbrm_date
            snapshot['ins_date_time'] = self.ins_datetime
            snapshot['asn'] = self.asn
            create_str = snapshot['creation']
            "20200319T06:47:06"
            create_date = datetime.datetime.strptime(create_str, "%Y%m%dT%H:%M:%S").strftime('%Y-%m-%d %H:%M:%S')
            snapshot['creation'] = create_date
            snapshot['cluster_name'] = self.cluster_name
            snapshot['space_unique'] = float(snapshot['space_unique'])
            snapshot['space_data'] = float(snapshot['space_data'])
            pool_snapshot_list.append(snapshot)
        # tb_name = 'zfs_snapshots_realtime'
        # tb_name_y = 'fbrm.' + tb_name + "_" + self.tb_c.to_day_y
        # self.tb_c.is_table_tb(tb_name)
        # self.db.dbInsertList(pool_snapshot_list, tb_name_y)
        query = "delete from live.live_zfs_snapshots where asn = '{}'".format(self.asn)
        self.db.queryExec(query)
        tb = 'live.live_zfs_snapshots'
        self.check_colume_key(pool_snapshot_list, tb)
        self.db.dbInsertList(pool_snapshot_list, tb)
        # with open('snapshot.txt','w') as f:
        #     f.write(ret_str)
        # print ret_str



    def search_snap(self,snap_name):
        zfs_list = self.get_zfs_list()
        for zfs_info in zfs_list:

            prj_list = self.get_projects()
            for href in self.prj_href_list:
                prg=href.split()[0]


    def main(self):
        prj_list=self.get_projects()
        for href in self.prj_href_list:
            prg=href.split()[0]
        self.get_filesystems()
        print('#'*50)
        self.get_snapshots()
        for snap in self.set_snapshot_list:
            href=snap['href']
            print(href)
            if 'Daily_Data_20220117_1001' in href:
                print(snap)
            if 'Daily_Arch_20220117_1001' in href:
                print(snap)
            # snap_creation = snap['creation']
            # dt = datetime.datetime.strptime(snap_creation, '%Y%m%dT%H:%M:%S')
            # now = datetime.datetime.now()
            # if now - datetime.timedelta(days=2) > dt:
            #     print(now - datetime.timedelta(days=2), now, dt)
            #     url=snap['href']
            #     print(url)
            #     self.zfs_conn.del_fs(url)
            # else:
            #     print(dt)
            #     print(datetime.timedelta(days=2))


class zfs_manager():
    def __init__(self):
        pass

    def search_snap(self,snap_name):
        print(snap_name)

    def get_zfs_list(self):
        cfg = configparser.RawConfigParser()
        cfg_file = os.path.join('config', 'list.cfg')
        cfg.read(cfg_file)
        zfs_list = list()
        for sec in cfg.sections():
            zfs_info = dict()
            zfs_info['zfs_name'] = sec
            for opt in cfg.options(sec):
                zfs_info[opt] = cfg.get(sec, opt)
            zfs_list.append(zfs_info)
        return zfs_list

    def main(self):
        zfs_list = self.get_zfs_list()
        snap_list = list
        for zfs_info in zfs_list:

            print(zfs_snaphosts(zfs_info).get_snapshots())

        for snap in snap_list:
            print(snap)

    def get_json_data(self):
        data_str="""{
	"telegramNum":"RQ050100",
	"reqNum":"202112210001",
	"project":"ORCL",
	"svrIp":"121.170.193.203",
	"oraVer":"Release 18.0.0.0.0",
	"oraSid":"CLONEDB1",
	"oraHome":"/u01/app/oracle/product/18c",
	"restoreDt":"2021/12/11 12:00:00",
	"resCd":"",
	"resDesc":"",
	"creDt":"20211221 15:00:01"	,
	"snapshots":[
		{
			"zfsIp":"121.170.193.213",
			"snapTyp":"DATA",
			"pool":"Pool1",
			"snapshot":"Daily_Data_20220127_1001",
			"share":"BAK_ORCL_01",
			"cloneMount":"CLONEDB1_BAK_ORCL_01",
			"sharePrefix":"CLONEDB1",
			"zfsUri":"/api/storage/v1/pools/Pool1/projects/ORCL/filesystems/BAK_ORCL_01/snapshots/Daily_Data_20220127_1001"
		},
		{
			"zfsIp":"121.170.193.213",
			"snapTyp":"DATA",
			"pool":"Pool2",
			"snapshot":"Daily_Data_20211221_1000",
			"share":"BAK_ORCL_01",
			"cloneMount":"CLONEDB1_BAK_ORCL_01",
			"sharePrefix":"CLONEDB1",
			"zfsUri":"/api/storage/v1/pools/Pool2/projects/ORCL/filesystems/BAK_ORCL_02/snapshots/Daily_Arch_20220127_1001"
		}
	]
}"""
        print(json.dumps(data_str))
        json_data = json.loads(data_str)
        print(json_data.keys())
        t_snap_list = json_data['snapshots']
        snap_name_list= list()
        for t_snap in t_snap_list:
            print(t_snap)
            print(t_snap['snapshot'])
            print(t_snap['zfsUri'])
            snap_name_list.append(t_snap['snapshot'])

        return snap_name_list

if __name__=='__main__':
    """
    [ZFS-88]
    ip=121.170.193.213
    port=215
    user=root
    passwd=welcome1
    """
    # zfs_info = dict()
    # zfs_info['zfs_name'] = 'ZFS-88'
    # zfs_info['ip'] = '121.170.193.213'
    # zfs_info['user'] = 'root'
    # zfs_info['passwd'] = 'welcome1'
    # zfs_info['port'] = '215'
    # zfs_snaphosts(zfs_info).main()

    # zfs_manager().main()
    zfs_manager().get_json_data()
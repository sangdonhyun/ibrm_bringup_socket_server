# -*-coding:utf-8-*-
"""
[ZFS-88]
ip=121.170.193.213
port=215
user=root
passwd=welcome1
curl --user root:welcome1 -k -i https://121.170.193.213:215//api/storage/v1/pools

table name : live.live_zfs_pools

"""
import os

import json
import ssl
import requests
import datetime
import fbrm_dbms

context = ssl._create_unverified_context()


#print os.popen("curl --user root:welcome1 -k -i https://121.170.193.213:215//api/storage/v1/pools").read()
class zfs_pools():
    def __init__(self,zfs_info):
        self.ip = zfs_info['ip']
        self.zfs_name = zfs_info['zfs_name']
        self.username = zfs_info['user']
        self.password = zfs_info['passwd']
        self.port = zfs_info['port']
        self.session = self.set_request()
        self.db = fbrm_dbms.fbrm_db()
        self.asn = self.get_asn()
        self.cluster_name = self.get_cluster_name()

    def get_cluster_name(self):
        query = "select cluster_name from master.master_zfs_cluster where ans = '{}'".format(self.asn)
        ret = self.db.getRaw(query)
        if len(ret) > 0:
            cluster_name = ret[0][0]
        else:
            cluster_name = self.zfs_name
        return cluster_name

    def get_asn(self):
        url = '/api/system/v1/version'
        full_url = self.get_url(url)
        root = self.get_request(full_url)
        # root = self.get_json(ret)
        zfs_info = root['version']
        return zfs_info['asn']

    def set_request(self):
        session = requests.Session()
        session.auth = (self.username, self.password)
        return session

    def del_fs(self,url):
        if 'https' not in url:
            full_url = self.get_url(url)
        else:
            full_url = url
        self.session.delete(full_url)

    def get_url(self,url):
        if 'https' not in url:
            full_url = 'https://{}:{}/{}'.format(self.ip,self.port,url)
        else:
            full_url = url
        return full_url

    def get_request(self,full_url):
        r = self.session.get(full_url, verify=False)
        body = json.loads(r.content)
        return body

    def zfs_base_info(self, asn):
        zfs_base = dict()
        zfs_base['fbrm_date'] = datetime.datetime.now().strftime('%Y-%m-%d')
        zfs_base['ins_date_time'] = datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S')
        query_str="SELECT CLUSTER_NAME FROM master.master_zfs_cluster mzc WHERE ASN = '{}'".format(asn)
        try:
            cluster_name = self.db.getRaw(query_str)[0][0]
        except Exception as e:
            cluster_name = ''
            print (str(e))
        zfs_base['zfs_name'] = self.zfs_name
        zfs_base['zfs_ip'] = self.ip
        zfs_base['cluster_ip'] = self.ip
        zfs_base['cluster_name'] = cluster_name
        zfs_base['node_name'] = self.zfs_name
        return zfs_base

    def json_to_str(self, json_content):
        return json.dumps(json_content, sort_keys=True, indent=4)

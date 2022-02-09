'''
Created on 2020. 4. 9.

@author: user
'''
# -*- encoding:cp949*-    
'''
Created on 2013. 2. 11.

@author: Administrator
'''

import sys
import os
import psycopg2
import configparser
import codecs
import locale



# import common


class fbrm_db():
    def __init__(self):
        #         self.com = common.Common()
        #         self.dec = common.Decode()
        #         self.logger = self.com.flog()
        #         self.conn_string = "host='localhost' dbname='fleta' user='fletaAdmin' password='kes2719!'"
        self.conn_string = self.getConnStr()
        self.cfg = self.getCfg()


    def getCfg(self):
        cfg = configparser.RawConfigParser()
        cfgFile = os.path.join('config', 'config.cfg')
        cfg.read(cfgFile)
        return cfg

    def getConnStr(self):
        """
        host = 121.170.193.201
        user = fbrmuser
        passwd = 'pcNwvyqrwaQ1dEigOJzghg=='
        dbname = ibrm
        port = 5432
        :return:
        """
        cfg = configparser.RawConfigParser()
        cfgFile = os.path.join('config', 'config.cfg')
        cfg.read(cfgFile)
        try:
            ip = cfg.get('database', 'ip')
        except:
            ip = 'localhost'
        try:
            user = cfg.get('database', 'user')
        except:
            user = 'fbrmuser'
        try:
            dbname = cfg.get('database', 'dbname')
        except:
            dbname = 'fbrm'
        try:
            passwd = cfg.get('database', 'passwd')
        except:
            passwd = 'fbrmpass'

        # if len(passwd) > 20:
        #     try:
        #         passwd = self.dec.fdec(passwd)
        #     except:
        #         pass

        if 'port' in cfg.options('database'):
            port = cfg.get('database', 'port')
            con_str = "host='%s' dbname='%s' user='%s' password='%s' port = '%s'" % (ip, dbname, user, passwd, port)
        else:
            con_str = "host='%s' dbname='%s' user='%s' password='%s'" % (ip, dbname, user, passwd)
        return con_str

    def getConnectInfo(self):
        dbinfo = {}
        for info in self.cfg.options('database'):
            val = self.cfg.get('database', info)
            if (info == 'passwd' or info == 'user') and len(val) > 20:
                val - self.dec.fdec(val)
            dbinfo[info] = val
        return dbinfo

    def getNow(self):
        return self.com.getNow('%Y%m%d%H%M%S')

    def queryExec(self, query):
        # print (self.conn_string)
        con = None
        try:
            con = psycopg2.connect(self.conn_string)
            cur = con.cursor()

            cur.execute(query)
            con.commit()

            # print ("Number of rows updated: %d" % cur.rowcount)
        except psycopg2.DatabaseError as e:
            if con:
                con.rollback()
            print ('Error %s' % str(e))
            sys.exit(1)
        finally:
            if con:
                con.close()
    def dbInsertList(self, dicList, table='fbrm.mon_rman_backup_list'):
        query_set = []
        ret_str = ''
        for dic in dicList:
            colList = dic.keys()
            valList = dic.values()
            colStr = '('
            for i in colList:
                colStr += "\"%s\"" % i + ','
            if colStr[-1] == ',':
                colStr = colStr[:-1] + ')'
            val = ()
            for i in valList:
                val += (i,)
            valStr = str(val)
            query_str = 'insert into %s %s values %s;' % (table, colStr, valStr)
            query_set.append(query_str)
            # print (query_str)
        con = None

        con = psycopg2.connect(self.conn_string)
        cur = con.cursor()
        for query_str in query_set:
            ret_str = ret_str + query_str + '\n'
            cur.execute(query_str)
        con.commit()
        # print ("Number of rows updated: %d" % cur.rowcount)
        return ret_str

    def getRaw(self, query_string):

        db = psycopg2.connect(self.conn_string)

        try:
            cursor = db.cursor()
            cursor.execute(query_string)
            rows = cursor.fetchall()

            cursor.close()
            db.close()

            return rows
        except:
            return []


if __name__ == '__main__':
    asn = '32c442b2-5779-c93b-9301-dc123ff292bb'
    query = """SELECT peer_hostname ,node_name FROM master.master_zfs_cluster WHERE zfs_serial LIKE '%{}%'""".format(
        asn)

    zfs = fbrm_db().getRaw(query)
    cluster_name = ''
    for z in zfs:
        cluster_name = '_'.join(sorted(set(z)))

    query = """SELECT *
  FROM information_schema.columns
 WHERE table_schema in ('master','live')
   AND table_name   LIKE  '%zfs%'
   AND column_name = 'cluster_name'
     ;"""
    rows = fbrm_db().getRaw(query)
    print (rows)

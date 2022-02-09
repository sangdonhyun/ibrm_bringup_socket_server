import asyncio
import json
import os


class bringup_socket_client():
    def __init__(self):
        pass

    def get_json(self,cmd,clone_arg):
        data = dict()
        data['password'] = 'kes2719!'
        data['cmd'] = cmd

        if cmd == 'data_clone':
            data['shell_exec'] = 'su - oracle -c "/ZFS/SCRIPTS/ibrm/ibrm_run_data_snapclone.sh {}"'.format(clone_arg)
        elif cmd == 'arch_clone':
            data['shell_exec'] = 'su - oracle -c "/ZFS/SCRIPTS/ibrm/ibrm_run_arch_snapclone.sh {}"'.format(clone_arg)
        elif cmd == 'mount_clone':
            data['shell_exec'] = '/ZFS/SCRIPTS/ibrm/mount_clone.sh {}'.format(clone_arg)
        elif cmd == 'umount_clone':
            data['shell_exec'] = '/ZFS/SCRIPTS/ibrm/umount_clone.sh {}'.format(clone_arg)


        json_data=json.dumps(data)
        return json_data

    async def tcp_echo_client(self,message):
        #121.170.193.203:9009
        reader, writer = await asyncio.open_connection(
            '121.170.193.203', 9009)
        print(message)
        print(f'Send: {message!r}')
        writer.write(message.encode())
        await writer.drain()

        data = await reader.read(1024)
        print(f'Received: {data.decode()!r}')

        print('Close the connection')
        writer.close()
        await writer.wait_closed()

    def main(self):
        send_data = self.get_json('umount_clone', 'ORCL')
        asyncio.run(self.tcp_echo_client(send_data))

        snapshot_name = 'Daily_Data_20220117_1001'
        send_data = self.get_json('data_clone',snapshot_name)
        asyncio.run(self.tcp_echo_client(send_data))

        arch_snapshot_name = 'Daily_Arch_20220117_1001'
        send_data = self.get_json('arch_clone', arch_snapshot_name)
        asyncio.run(self.tcp_echo_client(send_data))

        send_data = self.get_json('mount_clone', 'ORCL')
        asyncio.run(self.tcp_echo_client(send_data))

    def arch_snap(self):
        send_data = self.get_json('umount_snap', 'ORCL')
        arch_snapshot_name = 'Daily_Arch_20211218_1001'
        send_data = self.get_json('arch_clone', arch_snapshot_name)
        asyncio.run(self.tcp_echo_client(send_data))

    def get_owner(self,prj):
        owner = 'oracle'
        cmd='ps -ef | grep ora_pmon_{} | grep -v grep'.format(prj)
        lines=os.popen(cmd).readlines()
        for line in lines:
            owner = line.split()[0]
        return owner

    def json_test(self):
        """
        {'canonical_name': 'Pool1/local/ORCL/ARC_ORCL_01@Daily_Arch_20220117_1001', 'collection': 'local', 'creation': '20220117T01:02:53', 'numclones': 0, 'isauto': False, 'shadowsnap': False, 'id': 'd3a944cf-ad0e-509d-0000-000000000000', 'pool': 'Pool1', 'project': 'ORCL', 'share': 'ARC_ORCL_01', 'name': 'Daily_Arch_20220117_1001', 'type': 'snapshot', 'space_data': 3505843712, 'space_unique': 2380879872, 'href': '/api/storage/v1/pools/Pool1/projects/ORCL/filesystems/ARC_ORCL_01/snapshots/Daily_Arch_20220117_1001'}
        {'canonical_name': 'Pool1/local/ORCL/BAK_ORCL_01@Daily_Data_20220117_1001', 'collection': 'local', 'creation': '20220117T01:02:49', 'numclones': 0, 'isauto': False, 'shadowsnap': False, 'id': 'bcd24687-348c-c049-0000-000000000000', 'pool': 'Pool1', 'project': 'ORCL', 'share': 'BAK_ORCL_01', 'name': 'Daily_Data_20220117_1001', 'type': 'snapshot', 'space_data': 61440, 'space_unique': 49152, 'href': '/api/storage/v1/pools/Pool1/projects/ORCL/filesystems/BAK_ORCL_01/snapshots/Daily_Data_20220117_1001'}
        {'canonical_name': 'Pool2/local/ORCL/ARC_ORCL_02@Daily_Arch_20220117_1001', 'collection': 'local', 'creation': '20220117T01:02:57', 'numclones': 0, 'isauto': False, 'shadowsnap': False, 'id': '4fb00970-87b9-4558-0000-000000000000', 'pool': 'Pool2', 'project': 'ORCL', 'share': 'ARC_ORCL_02', 'name': 'Daily_Arch_20220117_1001', 'type': 'snapshot', 'space_data': 4307217408, 'space_unique': 3444752896, 'href': '/api/storage/v1/pools/Pool2/projects/ORCL/filesystems/ARC_ORCL_02/snapshots/Daily_Arch_20220117_1001'}
        {'canonical_name': 'Pool2/local/ORCL/BAK_ORCL_02@Daily_Data_20220117_1001', 'collection': 'local', 'creation': '20220117T01:02:53', 'numclones': 0, 'isauto': False, 'shadowsnap': False, 'id': '7b432067-c60d-f37e-0000-000000000000', 'pool': 'Pool2', 'project': 'ORCL', 'share': 'BAK_ORCL_02', 'name': 'Daily_Data_20220117_1001', 'type': 'snapshot', 'space_data': 52224, 'space_unique': 35840, 'href': '/api/storage/v1/pools/Pool2/projects/ORCL/filesystems/BAK_ORCL_02/snapshots/Daily_Data_20220117_1001'}

        :return:
        """
        re_data ="""
{
	"telegramNum":"RQ050100",
	"reqNum":"202112210001",
	"project":"ORCL",
	"svrIp":"121.170.193.203",
	"oraVer":"Release 18.0.0.0.0",
	"oraSid":"CLONEDB1",
	"oraHome":"/u01/app/oracle/product/18c",
	"restoreDt":"2021/12/11 12:00:00",
	"resCd":"200/400",
	"resDesc":"SUCC/FAIL",
	"creDt":"20211221 15:00:01"	,
	"snapshots":[
		{
			"zfsIp":"121.170.193.213",
			"snapTyp":"DATA",
			"pool":"Pool1",
			"snapshot":"Daily_Data_20220207_1018",
			"share":"BAK_ORCL_01",
			"cloneMount":"CLONEDB1_BAK_ORCL_01",
			"sharePrefix":"CLONEDB1",
			"zfsUri":"/api/storage/v1/pools/Pool1/projects/ORCL/filesystems/BAK_ORCL_01/snapshots/Daily_Data_20220207_1018"

		},
		{
			"zfsIp":"121.170.193.213",
			"snapTyp":"DATA",
			"pool":"Pool2",
			"snapshot":"Daily_Data_20220207_1018",
			"share":"BAK_ORCL_01",
			"cloneMount":"CLONEDB1_BAK_ORCL_01",
			"sharePrefix":"CLONEDB1",
			"zfsUri":"/api/storage/v1/pools/Pool2/projects/ORCL/filesystems/BAK_ORCL_02/snapshots/Daily_Data_20220207_1018"
		},
		{
			"zfsIp":"121.170.193.213",
			"snapTyp":"ARCH",
			"pool":"Pool1",
			"snapshot":"Daily_Arch_20220207_1514",
			"share":"ARC_ORCL_01",
			"cloneMount":"CLONEDB1_ARC_ORCL_01",
			"sharePrefix":"CLONEDB1",
			"zfsUri":"/api/storage/v1/pools/Pool1/projects/ORCL/filesystems/ARC_ORCL_01/snapshots/Daily_Arch_20220207_1514"
		},
		{
			"zfsIp":"121.170.193.213",
			"snapTyp":"ARCH",
			"pool":"Pool2",
			"snapshot":"Daily_Arch_20220207_1514",
			"share":"ARC_ORCL_02",
			"cloneMount":"CLONEDB1_ARC_ORCL_02",
			"sharePrefix":"CLONEDB1",
			"zfsUri":"/api/storage/v1/pools/Pool2/projects/ORCL/filesystems/ARC_ORCL_02/snapshots/Daily_Arch_20220207_1514"
		}
	]
}"""
#Daily_Arch_20220207_1514
        j_data = json.loads(re_data)
        print(j_data)
        print(type(j_data))
        print(j_data.keys())
        req_num = j_data['telegramNum']
        ret_num = 'RC'+req_num[3:]
        keys = ['telegramNum', 'reqNum', 'project', 'svrIp', 'oraVer', 'oraSid', 'oraHome', 'restoreDt', 'resCd', 'resDesc', 'creDt', 'snapshots']
        snap_data_list = list()
        snap_arch_list = list()
        prj = j_data['project']
        for key in keys:
            print(key,j_data[key])
            if key=='snapshots':
                for snap in j_data['snapshots']:
                    print (snap)
                    if snap['snapTyp'] == 'DATA':
                        if snap['snapshot'] not in snap_data_list:
                            snap_data_list.append(snap['snapshot'])
                    elif snap['snapTyp'] == 'ARCH':
                        if snap['snapshot'] not in snap_arch_list:
                            snap_arch_list.append(snap['snapshot'])
                    else:
                        pass
        if isinstance(j_data,dict):
            j_data = json.dumps(j_data)
        asyncio.run(self.tcp_echo_client(j_data))



if __name__=='__main__':
    bringup_socket_client().json_test()
import asyncio
import logging
import os
import subprocess
import shlex
import threading
import time
import json
import datetime
import queue
import socket
import select
import data_recovery

# XXX: REMOVE THIS LINE IN PRODUCTION!
logging.basicConfig(format='%(asctime)s %(lineno)d %(levelname)s:%(message)s', level=logging.DEBUG)
logger = logging.getLogger(__name__)

# Connected client records
clients = dict()

q = queue.Queue()



class brinup(object):
    """
    step
    input snapshot name
    1. ZFS DATA CLONE NFS
    2. ZFS ARCH CLONE NFS
    3. mount NFS

    4. control file make ==>  /tmp/catalog_start.sql
    5. catalog make ==> catalog make and start
    6. trace control file => alter database backup controlfile to trace as '/tmp/trace_control.sql'
    """

    def __init__(self, json_data, interval=1):

        self.interval = interval
        self.json_data = json_data
        print('bringup start ')
        thread = threading.Thread(target=self.run, args=(q,))
        # thread.daemon = False
        print ('thread daemon :',thread.daemon)
        thread.start()  # Start the execution
        time.sleep(interval)
        thread.join()

    def get_owner(self,prj):
        owner = 'oracle'
        cmd='ps -ef | grep ora_pmon_{} | grep -v grep'.format(prj)
        lines=os.popen(cmd).readlines()
        for line in lines:
            owner = line.split()[0]
        return owner

    def get_snap_list(self):
        snap_data_list = list()
        snap_arch_list = list()
        prj = self.json_data['project']
        keys = self.json_data.keys()
        snap_data_list = list()
        snap_arch_list = list()
        if 'snapshots' in keys:
            for snap in self.json_data['snapshots']:
                print(snap)
                if snap['snapTyp'] == 'DATA':
                    if snap['snapshot'] not in snap_data_list:
                        snap_data_list.append(snap['snapshot'])
                elif snap['snapTyp'] == 'ARCH':
                    if snap['snapshot'] not in snap_arch_list:
                        snap_arch_list.append(snap['snapshot'])
                else:
                    pass
        return snap_data_list,snap_arch_list

    def cmd_excute(self,cmd):
        std_out=os.popen(cmd).read()
        # p = subprocess.call(shlex.split(cmd), shell=True)
        # pid = p.pid
        # std_out, std_err = p.communicate()
        # print('PID :', pid)
        # print('std_out :', std_out)
        # print('std_err :', std_err)
        return std_out

    def run(self,queue):
        brinup_process = data_recovery.bring_up()
        """ Method that runs forever """
        # Do something
        print('BRIGUP STEP 0 ')
        #umount nfs clonedb directory
        cmd = 'sh /ZFS/SCRIPTS/ibrm/umount_clone.sh'
        print("CMD :", cmd)
        self.cmd_excute(cmd)

        owner = self.get_owner(self.json_data['project'])
        snap_data_list,snap_arch_list =self.get_snap_list()
        print('BRIGUP STEP 1 ')
        print('DATASNAP CLONE')
        for snap_data in snap_data_list:
            cmd = 'su - {OWNER} -c "sh /ZFS/SCRIPTS/ibrm/ibrm_run_data_snapclone.sh {SNAP_NAME}"'.format(OWNER=owner,SNAP_NAME=snap_data)
            print("CMD :", cmd)
            self.cmd_excute(cmd)
        print('BRIGUP STEP 2 ')
        print('ARCHSNAP CLONE')
        for snap_arch in snap_arch_list:
            cmd = 'su - {OWNER} -c "sh /ZFS/SCRIPTS/ibrm/ibrm_run_arch_snapclone.sh {SNAP_NAME}"'.format(OWNER=owner,SNAP_NAME=snap_arch)
            print("CMD :", cmd)
            self.cmd_excute(cmd)
        print('BRIGUP STEP 3 ')
        print('MOUNT ZFS')
        cmd = 'sh /ZFS/SCRIPTS/ibrm/mount_clone.sh'
        print("CMD :", cmd)
        self.cmd_excute(cmd)

        print('BRIGUP STEP 4 ')
        print('control file make')
        brinup_process.make_control_file()

        print('BRIGUP STEP 5 ')
        print('backup catalog')
        brinup_process.backup_catalog()

        print('BRIGUP STEP 6 ')
        print('control file trace')
        brinup_process.trace_control_file()

        start_time = datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S')


        time.sleep(self.interval)
        print('brinup process end')
        print(datetime.datetime.now())
        out_data = dict()
        queue.put(out_data)



async def show_tasks():
    """FOR DEBUGGING"""
    while True:
        await asyncio.sleep(5)
        logger.debug(asyncio.Task.all_tasks())


def client_connected_cb(client_reader, client_writer):
    # Use peername as client ID
    client_id = client_writer.get_extra_info('peername')

    logger.info('Client connected: {}'.format(client_id))

    # Define the clean up function here
    def client_cleanup(fu):
        logger.info('Cleaning up client {}'.format(client_id))
        try:  # Retrievre the result and ignore whatever returned, since it's just cleaning
            fu.result()
        except Exception as e:
            pass
        # Remove the client from client records
        del clients[client_id]

    task = asyncio.ensure_future(client_task(client_reader, client_writer))
    task.add_done_callback(client_cleanup)
    # Add the client and the task to client records
    clients[client_id] = task



async def client_task(reader, writer):
    client_addr = writer.get_extra_info('peername')
    logger.info('Start echoing back to {}'.format(client_addr))

    while True:
        data = await reader.read(1024*8)
        print(data)
        print(type(data))
        if data == b'':
            logger.info('Received EOF. Client disconnected.')
            return
        else:
            # print('data :', data, type(data))
            recv_data=data.decode('utf-8')
            # recv_data = recv_data.replace("'",'"')
            json_data = json.loads(recv_data)
            print(json_data)
            ret_dict = dict()

            print(ret_dict)
            ret_dict['return_code'] = os.popen('echo $?').read()
            ret_dict['std_out'] = 'test'
            ret_dict['end_time'] = datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S')
            json_ret_data = json.dumps(ret_dict)
            brinup(json_data=json_data, interval=1)

            writer.write(json_ret_data.encode('utf-8'))
            await writer.drain()




if __name__ == '__main__':
    HOST = '121.170.193.203'
    PORT = 9009
    loop = asyncio.get_event_loop()
    server_coro = asyncio.start_server(client_connected_cb,
                                       host=HOST,
                                       port=PORT,
                                       loop=loop)
    server = loop.run_until_complete(server_coro)

    try:
        logger.info('Serving on {}:{}'.format(HOST, PORT))
        loop.run_forever()
    except KeyboardInterrupt as e:
        logger.info('Keyboard interrupted. Exit.')
    # Close the server
    server.close()
    loop.run_until_complete(server.wait_closed())
    loop.close()
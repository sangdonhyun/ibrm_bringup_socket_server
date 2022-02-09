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

# XXX: REMOVE THIS LINE IN PRODUCTION!
logging.basicConfig(format='%(asctime)s %(lineno)d %(levelname)s:%(message)s', level=logging.DEBUG)
logger = logging.getLogger(__name__)

# Connected client records
clients = dict()

q = queue.Queue()

class run_shell(object):
    """ Threading example class
    The run() method will be started and it will run in the background
    until the application exits.
    """

    def __init__(self, cmd, interval=1):
        """ Constructor
        :type interval: int
        :param interval: Check interval, in seconds
        """
        self.interval = interval
        self.cmd = cmd
        thread = threading.Thread(target=self.run, args=(q,))
        # thread.daemon = False
        print ('thread daemon :',thread.daemon)
        thread.start()  # Start the execution
        time.sleep(interval)
        thread.join()


    def run(self,queue):
        """ Method that runs forever """
        # Do something
        print('Doing JOB_SUBMIT in the background')
        print("CMD :"+self.cmd)
        start_time = datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S')
        p=subprocess.call(shlex.split(self.cmd), shell=True)
        pid = p.pid
        std_out, std_err = p.communicate()
        print ('PID :',pid)
        print('std_out :', std_out)
        print('std_err :', std_err)
        with open(os.path.join('logs','{}_out.txt'.format(pid)),'w') as fw:
            fw.write('#'*50)
            fw.write("START :"+datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S'))
            fw.write(std_out)
            fw.write('\n')
            fw.write("END :"+datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S'))
        with open(os.path.join('logs','{}_err.txt'.format(pid)),'w') as fw:
            fw.write('#' * 50)
            fw.write("START :" + datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S'))
            fw.write(std_out)
            fw.write('\n')
            fw.write("END :"+datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S'))
        with open('pid.txt','w') as fw:
            fw.write(pid)
        print('cmd :', self.cmd)
        time.sleep(self.interval)
        print('subprocess job-end')
        print(datetime.datetime.now())
        out_data = dict()
        out_data[self.cmd] = std_out
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
        data = await reader.read(1024)

        if data == b'':
            logger.info('Received EOF. Client disconnected.')
            return
        else:
            # print('data :', data, type(data))
            recv_data=data.decode('utf-8')
            recv_data = recv_data.replace("'",'"')
            json_data = json.loads(recv_data)
            print(json_data)
            print(json_data['cmd'])
            ret_data = dict()
            ret_data['psssword'] = "kes2719!"
            ret_data['cmd'] = json_data['shell_exec']
            ret_data['start_time'] = datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S')
            ret = ""
            if json_data['cmd'] == 'data_recovery':
                cmd = 'python3 /fleta/asyncio_server/data_recovery.py'
                ret= os.popen(cmd).read()

            if json_data['cmd'] == 'arch_recovery':
                arch_date = json_data['arch_date']
                arch_time = json_data['arch_time']
                print(json_data)
                cmd = 'python3 /fleta/asyncio_server/arch_recovery.py {} {}'.format(arch_date,arch_time)
                print(cmd)
                ret = os.popen(cmd).read()
            else:

                # if json_data['cmd'] == 'data_clone':
                #     cmd = json_data['shell_exec']
                #     print (cmd)
                #     run_shell(cmd=cmd, interval=1)


                # p = subprocess.call(shlex.split(json_data['shell_exec']), shell=True)
                # pid = p.pid
                # std_out, std_err = p.communicate()
                # print("STDOUT : "+std_out)
                # print("STDERR : "+std_err)
                # print("PID : " + pid)
                ret=os.popen(json_data['shell_exec']).read()
            print(ret)
            ret_data['return_code'] = os.popen('echo $?').read()
            ret_data['std_out'] = ret
            ret_data['end_time'] = datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S')
            json_ret_data = json.dumps(ret_data)

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
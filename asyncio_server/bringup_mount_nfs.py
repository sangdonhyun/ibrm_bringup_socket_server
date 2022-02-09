import asyncio
import json

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

        send_data = self.get_json('mount_clone', 'ORCL')
        asyncio.run(self.tcp_echo_client(send_data))



if __name__=='__main__':
    bringup_socket_client().main()
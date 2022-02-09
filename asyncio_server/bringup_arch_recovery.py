import asyncio
import json

class bringup_socket_client():
    def __init__(self):
        pass

    def get_json(self, ins_data):
        cmd = ins_data['cmd']
        data = dict()
        data['password'] = 'kes2719!'
        data['cmd'] = cmd

        if cmd == 'data_recovery':
            data['shell_exec'] = ''
        elif cmd == 'arch_recovery':
            arch_date = ins_data['arch_date']
            arch_time = ins_data['arch_time']
            data['arch_date'] = arch_date
            data['arch_time'] = arch_time
            data['shell_exec'] = ''
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
        arch_date = '2021/12/22'
        arch_time = '17:30:00'
        data = dict()
        data['arch_date'] = arch_date
        data['arch_time'] = arch_time
        data['cmd'] = 'arch_recovery'
        print (data)
        send_data = self.get_json(data)
        asyncio.run(self.tcp_echo_client(send_data))


if __name__=='__main__':
    bringup_socket_client().main()
import asyncio


data = dict()
data['password'] = 'kes2719!'
data['cmd'] = 'run'
data['shell_exec'] = '/tmp/test.sh'
send_data = str(data)


async def tcp_echo_client(message):
    reader, writer = await asyncio.open_connection(
        '192.168.56.14', 9009)

    print(f'Send: {send_data!r}')
    writer.write(send_data.encode())
    await writer.drain()

    data = await reader.read(100)
    print(f'Received: {data.decode()!r}')

    print('Close the connection')
    writer.close()
    await writer.wait_closed()



asyncio.run(tcp_echo_client(send_data))
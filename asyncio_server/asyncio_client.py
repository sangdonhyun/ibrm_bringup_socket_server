import asyncio


data = dict()
data['password'] = 'kes2719!'
data['cmd'] = 'run'
data['shell_exec'] = '/tmp/test.sh'
send_data = str(data)


async def tcp_echo_client(message):
    reader, writer = await asyncio.open_connection(
        '121.170.193.203', 9009)
    print(message)
    print(f'Send: {message!r}')
    if isinstance(message,str):
        message = message.encode()
    writer.write(message)
    await writer.drain()

    data = await reader.read(100)
    print(f'Received: {data.decode()!r}')

    print('Close the connection')
    writer.close()
    await writer.wait_closed()



asyncio.run(tcp_echo_client(send_data))

import socket
data = dict()
data['password'] = 'kes2719!'
data['cmd'] = 'run'
data['shell_exec'] = '/tmp/test.sh'
data_str = str(data)
send_data = data_str.encode()
print(send_data)
sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
HOST,PORT= '121.170.193.203', 9009
sock.connect((HOST, PORT))
sock.sendall(send_data)
received = sock.recv(1024)
print (received)
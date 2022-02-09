import socket

class ibrm_socket_client():
    def __init__(self):
        pass

    def to_bytes(self,data):
        if not isinstance(data,bytes):
            data = str(data).encode()
        return data
    def send_data(self,data):
        sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        sBit = False
        HOST,PORT='192.168.56.14', 9009
        data = dict()
        data['password'] = 'kes2719!'
        data['cmd'] = 'run'
        data['shell_exec'] = '/tmp/test.sh'

        # Connect to server and send data
        sock.connect((HOST, PORT))
        data = self.to_bytes(data)
        sock.sendall(data)
        # Receive data from the server and shut down
        received = sock.recv(1024)
        print('recv :',received)
        sock.close()

if __name__=='__main__':
    data = {}
    data['FLETA_PASS'] = 'kes2719!'
    data['CMD'] = 'AGENT_SHELL_LIST'
    data['ARG'] = {}
    data['ARG']['db_name'] = 'UPGR'
    ibrm_socket_client().send_data(data)
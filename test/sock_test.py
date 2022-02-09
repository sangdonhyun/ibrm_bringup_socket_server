import socket
import threading
import select

def l():
    global incomming,addr
    a = socket.socket(socket.AF_INET,socket.SOCK_STREAM)
    a.bind(('localhost',9999))
    a.listen(1)
    incomming,addr = a.accept()
    a.close()
    print addr

def c():
    global outgoing
    a = socket.socket(socket.AF_INET,socket.SOCK_STREAM)
    a.connect(('localhost',9999))
    outgoing = a
    print 'connected'



threading.Thread(target=1).start()
c()

outgoing.send('hello')
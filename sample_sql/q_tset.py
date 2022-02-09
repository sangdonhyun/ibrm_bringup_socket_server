
import queue


ibrm_queue = queue.Queue()

ibrm_queue.put('1')
ibrm_queue.put('2')
ibrm_queue.put('3')
ibrm_queue.put('4')
ibrm_queue.put('5')
ibrm_queue.put('6')


print(ibrm_queue)
print("size :",ibrm_queue.qsize())
for i in range(ibrm_queue.qsize()):
    print(i)
    job=ibrm_queue.get()
    if not job== '3':
        ibrm_queue.put(job)

print("size :",ibrm_queue.qsize())
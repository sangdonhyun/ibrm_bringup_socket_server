import queue


data_queue = queue.Queue()

job_info = dict()

job_info['oracle_sid'] ="ORCL"
job_info['pid'] =""
job_info['session_id'] =""
job_info['job_id'] =""
job_info['shell_name'] =""
job_info['shell_type'] =""
job_info['db_name'] =""
job_info['start_time'] =""
job_info['tg_job_dtl_id'] =""
job_info['job_status'] =""

data_queue.put(job_info)

print(data_queue.qsize())

print(list(data_queue))

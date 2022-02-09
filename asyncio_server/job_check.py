import os

class job_check():
    def __init__(self,job_info):
        self.job_info = job_info
        self.submit_job_list = self.get_job_submit(self.job_info['job_exec_dt'])

    def get_job_submit(self,job_exec_dt):
        with open('/iBRM/ibrm_agent_v1.2/job_submit.txt') as f:
            lines = f.readlines()
        job_exec_list=list()
        for line in lines:
            line.split()

    def get_job_status_for_submit(self):
        job_dtl_id = self.job_info['job_dtl_id']
        job_dtl_id = self.job_info['job_dtl_id']
        job_exec_dt = self.job_info['job_dtl_id']
        job_submit_list = self.get_job_submit(job_exec_dt)


    def main(self):
        pass

if __name__=='__main__':
    job_info = {'tg_job_dtl_id': 3335, 'job_id': 18, 'shell_name': 'ORCL_archivelog.sh', 'db_name': 'ORCL', 'job_exec_dt': '20211222'}
    job_check(job_info).main()


# query="""
# CREATE TABLE ibrm_test1
# (
#     name       VARCHAR2(10),
#     datetime  DATE
# );
# """
import os


query_file = '/tmp/ins_ibrm_test1.sql'
with open(query_file,'w') as f:
    f.write("select 'MAX,',max(name) from ibrm_test1;")
cmd = """su - oracle -c "export ORACLE_SID=ORCL;sqlplus '/as sysdba' < {}"
""".format(query_file)
ret=os.popen(cmd).read()
print (ret)
max_num=0

for line in ret.splitlines():
    if 'MAX,' in line:
        max_num = line.split(',')[-1].strip()
print('max_num', max_num)
query=''
for i in range(int(max_num),int(max_num)+100):
    print(i)
    query = query + "INSERT INTO ibrm_test1 VALUES( '{}', SYSDATE);\n".format(str(i))

ins_query_file = '/tmp/ins_query.sql'
with open(ins_query_file,'w') as fw:
    fw.write(query)

cmd = """su - oracle -c "export ORACLE_SID=ORCL;sqlplus '/as sysdba' < {}"
""".format(ins_query_file)

ret=os.popen(cmd).read()
print(ret)


with open('ins_query1.txt','w') as fw:
    fw.write(query)


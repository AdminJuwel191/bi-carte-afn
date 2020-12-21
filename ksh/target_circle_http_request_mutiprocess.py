import sys
import json
import datetime
import mysql.connector
from mysql.connector import Error
import requests
from multiprocessing import Process, Pipe


class http_request_cl(object):
        def __init__(self, x_api_token, file_name, api_call, request_group, arl):
                                                                                self.x_api_token = x_api_token
                                                                                self.file_name = file_name
                                                                                self.api_call = api_call
                                                                                self.request_group = request_group
                                                                                self.api_request_list = arl

        def http_request(self, instance, conn):
                                         empty_list = ["{'token':'token','data':[]}", "{'token': '', 'data': []}", "","{'data': [], 'token': ''}"]
                                         offset = 1
                                         try:
                                             while str(requests.get(instance.api_call.replace('{replace_offset}', str((offset - 1) * 50)), headers={"X-Api-Token =": instance.x_api_token}).json()) not in empty_list:
                                                 with open(instance.file_name.replace('${FILE_HOME}', '/home/') + '_' + str(offset) + '.js', 'w') as outfile:
                                                     json.dump(requests.get(instance.api_call.replace('{replace_offset}', str((offset - 1) * 50)), headers={"X-Api-Token =": instance.x_api_token}).json(), outfile)
                                                     offset = offset + 1
                                                 continue
                                             conn.close()
                                         except Exception as e:
                                                              print(e)
                                                              raise e

        def multiprocess(self):
                               processes = []
                               for instance in self.api_request_list:
                                    parent_conn, child_conn = Pipe()
                                    process = Process(target=self.http_request, args=(instance, child_conn))
                                    processes.append(process)

                                # start all processes
                               for process in processes:
                                    process.start()
                                    #print(process)
                                # make sure that all processes have finished
                               for process in processes:
                                    process.join()


if __name__ == '__main__':
    try:
        mysqlconnection = mysql.connector.connect(host='bi-dwh-aurora-prod.cuponation.com',
                                                  database='aff_networks',
                                                  user='bi',
                                                  password='rSe2Sa9fZKkZTXm')
    except Error as e:
        print("Error while connecting to MySQL", e)
    sql_select_query = "call target_circle_http_request("+str(sys.argv[1])+")"
    cursor = mysqlconnection.cursor()
    cursor.execute(sql_select_query)
    records = cursor.fetchall()
    api_request_group_list = []    # requests are diveded in groups(<=100 per group) in order to avoid failures invoking huge number of requests during multiprocessin further in the script
    api_request_list = []   # all requests retrieved by the cursor
    print('start_time', datetime.datetime.now())
    for row in records:
        x_api_token = row[1]
        file_name = row[2]
        api_call = row[3]
        request_group = row[7]
        api_request_group_list.append(request_group)    # list of all request groups
        obj1 = http_request_cl(x_api_token, file_name, api_call, request_group, '')    # create object per request
        api_request_list.append(obj1)    # list of all objects per request
    api_request_group_list = list(dict.fromkeys(api_request_group_list))    # create distinct values request groups list

    for row in api_request_group_list:
        api_request_list_pom = []
        for row2 in api_request_list:
            if row2.request_group == row:
                api_request_list_pom.append(row2)
        obj2 = http_request_cl('', '', '', '', api_request_list_pom)
        obj2.multiprocess()
    cursor.close()
    mysqlconnection.close()
    print('end_time', datetime.datetime.now())
    print("MySQL connection is closed")


import sys
import json
import datetime
import mysql.connector
import requests
import time

def http_request(records):
    for row in records:
        authorization = row[1]
        accept = row[2]
        file_name = row[3]
        print("file_name:", file_name)
        api_call = row[4]
        start_date = row[5]
        end_date = row[6]
        headers = {'Authorization': authorization, 'Accept': accept}
        page = 0
        while True:
            while True:
                r = requests.get(api_call.replace('{replace_page}', str(page)), headers=headers)
                if (int(r.status_code) != 429):
                    break
                else:
                  try:
                    time.sleep(int(r.headers['Retry-After'])) 
                  except:
                    time.sleep(5)
            print("r.json:", r)
            if str((r.json())['data']) not in ('[]'):
                with open(file_name.replace('${FILE_HOME}', '/home/') + '_'+ str(start_date) +'_'+ str(end_date) +'_'+ str(page) + '.js', 'w') as outfile:
                     json.dump(r.json(), outfile)
                     page = page + 1
            else:
                break

if __name__ == '__main__':
    mysqlconnection = mysql.connector.connect(host='136.243.82.74',
                                                  database='aff_networks',
                                                  user='bi',
                                                  password='rSe2Sa9fZKkZTXm')

    sql_select_query = "call aff_networks.digidip_http_request("+str(sys.argv[1])+")"
    cursor = mysqlconnection.cursor()
    cursor.execute(sql_select_query)
    records = cursor.fetchall()
    print('start_time', datetime.datetime.now())
    http_request(records)
    cursor.close()
    mysqlconnection.close()
    print('end_time', datetime.datetime.now())
    print("MySQL connection is closed")


import sys
import json
import datetime
import mysql.connector
import requests
import time

def http_request(records):
    for row in records:
        apikey = row[1]
        accept = row[2]
        file_name = row[3]
        api_call = row[4]
        start_date = row[5]
        end_date = row[6]
        headers = {'ApiKey': apikey, 'Accept': accept}
        page = 1
        while True:
              r = requests.get(api_call.replace('{replace_page}', str(page)), headers=headers)              
              if (int(r.status_code) == 200):
                with open(file_name.replace('${FILE_HOME}', '/home/') + '_'+ str(page) + '.js', 'w') as outfile:
                    json.dump(r.json(), outfile)
                    page = page + 1
              else:
                break

if __name__ == '__main__':
    mysqlconnection = mysql.connector.connect(host='bi-dwh-aurora-prod.cuponation.com',
                                                  database='aff_networks',
                                                  user='bi',
                                                  password='rSe2Sa9fZKkZTXm')

    sql_select_query = "call aff_networks.flexoffers_http_request("+str(sys.argv[1])+")"
    cursor = mysqlconnection.cursor()
    cursor.execute(sql_select_query)
    records = cursor.fetchall()
    print('start_time', datetime.datetime.now())
    http_request(records)
    cursor.close()
    mysqlconnection.close()
    print('end_time', datetime.datetime.now())
    print("MySQL connection is closed")


#!/usr/bin/python3
# -*- coding: utf-8 -*-
"""
Script for downloading Transactions from OTO API.
"""
import sys
import pymysql
import pandas
import requests
FILE_HOME=b"/home/"
FROM_DAYS=sys.argv[2]
TO_DAYS=sys.argv[3]
print("The job is running from days: ", FROM_DAYS)
print("The job is running to days: ", TO_DAYS)


host = "136.243.82.74"
port=3306
dbname="aff_networks"
user="bi"
password="rSe2Sa9fZKkZTXm"

try:
    conn = pymysql.connect(host, user=user,port=port, passwd=password, db=dbname)
    select_sql = "SELECT REPLACE(REPLACE(REPLACE(m.api_request, '{replace_start_date}', date_format(d.start_date, '%Y-%m-%d')),'{replace_end_date}', date_format(d.end_date, '%Y-%m-%d')), '{replace_api_key}',m.api_key)  AS api_request, CONCAT(m.file_location, m.transaction_source, '_', m.country_iso, '_', m.file_name, '_', m.affiliate_network, '_', m.currency, '_', affnetwork_id, '_', date_format(d.start_date, '%Y-%m-%d'), '_', date_format(d.end_date, '%Y-%m-%d')) AS file_name, '' AS empty_string FROM aff_networks.metadata_cn_oqu m CROSS JOIN (SELECT min(date) AS start_date, max(date) AS end_date FROM mart_dwh_v_2.d_date WHERE date >= current_date-INTERVAL ${FROM_DAYS} day AND date <= current_date-INTERVAL  ${TO_DAYS} day AND date >='2017-01-01' ORDER BY date ASC) d WHERE transaction_source = 'CN';"
    select_sql = select_sql.replace('${FROM_DAYS}', FROM_DAYS)
    select_sql = select_sql.replace('${TO_DAYS}', TO_DAYS)
    pandas_df=pandas.read_sql(select_sql, con=conn)
except:
       sys.out.println("Connection failed")
try:
    for index, row in pandas_df.iterrows():
        content = requests.get(row['api_request'])
        if content.status_code != 200:
            print("ERROR:Api Request : " + str(row['api_request'])+ "FAILED!!! with the RESPONSE CODE"+ str(content.status_code))
        else:
            print("Response: " + str(content.status_code))
        print(row['file_name'].encode('utf-8'))
        file_path=row['file_name'].encode('utf-8').replace(b'${FILE_HOME}',FILE_HOME)+b".csv"
        if content.text != '':
            with open(file_path, 'wb') as filehandle:
                filehandle.write(content.text.encode('utf-8'))
                filehandle.close()
except:
       print("ERROR:Loading of the requests failed")

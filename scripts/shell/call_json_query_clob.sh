#!/bin/bash


sqlcl_script=query_blob.sql

sqlcl=/c/WinApp/oracle/sqlcl/bin/sql
dburl=david/alexgo12@192.168.1.2:1521/XE

# doesn't work!
# ${sqlcl} -s ${dburl} ${sqlcl_script} 

# this is working
dburl=david/alexgo12@192.168.1.2:1521/XE
cat ${sqlcl_script} | ${sqlcl} -s ${dburl} 


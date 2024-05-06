#!/bin/bash

p_city=${1}
#p_status=${2}

sqlcl_script=call_ref_cursor.sql

sqlcl=/c/WinApp/oracle/sqlcl/bin/sql
dburl=david/alexgo12@192.168.1.2:1521/XE

# doesn't work!
# ${sqlcl} -s ${dburl} ${sqlcl_script} 

# this is working
cat ${sqlcl_script} | ${sqlcl} -s ${dburl} 

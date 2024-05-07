#!/bin/bash

p_city=$1
p_status=$2

sqlcl_script=$(cat <<EOF
SET SERVEROUTPUT ON;
DECLARE
  v_count NUMBER := 0;
BEGIN
  LIST_HOUSE_JSON;
  
  DBMS_OUTPUT.PUT_LINE('Count: ' || v_count);

EXCEPTION
  -- Handle potential exceptions
  WHEN NO_DATA_FOUND THEN
    DBMS_OUTPUT.PUT_LINE('No Data Found Error');
  
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Other. Please check logs for details.');
    RAISE; -- Re-raise the exception for further handling
END;
/
EXIT;
EOF
)

# E:\Oracle\sqlcl\bin
# sqlcl=/c/WinApp/oracle/sqlcl/bin/sql
sqlcl=/e/Oracle/sqlcl/bin/sql
dburl=david/alexgo12@192.168.1.2:1521/XE
echo "$sqlcl_script" | ${sqlcl} -s ${dburl}

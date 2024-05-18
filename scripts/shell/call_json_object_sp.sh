#!/bin/sh
#
# E:\Oracle\sqlcl\bin
# sqlcl=/c/WinApp/oracle/sqlcl/bin/sql
sqlcl=/e/Oracle/sqlcl/bin/sql
dburl=david/alexgo12@192.168.1.2:1521/XE

sqlcl_script=$(echo "
SET SERVEROUTPUT ON SIZE 32767;
DECLARE
  v_count NUMBER := 0;
  
BEGIN
  --DMBS_OUTPUT.ENABLE(buffer_size => NULL);
  LIST_HOUSE_JSON;
  
  --DBMS_OUTPUT.PUT_LINE('Count: ' || v_count);

EXCEPTION
  -- Handle potential exceptions
  WHEN NO_DATA_FOUND THEN
    DBMS_OUTPUT.PUT_LINE('No Data Found Error');
  
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Other. Please check logs for details.');
    RAISE; -- Re-raise the exception for further handling
END;
/
EXIT;"| ${sqlcl} -s ${dburl}
)
echo "$sqlcl_script" #| /e/Python/Python39/python -m json.tool

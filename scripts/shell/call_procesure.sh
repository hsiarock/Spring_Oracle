#!/bin/bash

p_city=$1
p_status=$2

sqlcl_script=$(cat <<EOF
SET SERVEROUTPUT ON;
DECLARE
  v_summary VARCHAR2(4000);
  v_count NUMBER;
BEGIN
  LIST_HOUSE(${p_city}, ${p_status}, v_summary, v_count);
  
  -- Print the OUT parameters
  DBMS_OUTPUT.PUT_LINE('Summary: ' || v_summary);
  DBMS_OUTPUT.PUT_LINE('Count: ' || TO_CHAR(v_count));

EXCEPTION
  -- Handle potential exceptions
  WHEN NO_DATA_FOUND THEN
    DBMS_OUTPUT.PUT_LINE('Found Error: ' || ${p_city} || ' not found.');
    v_summary := 'No Data Found for list City:' || ${p_city} || ', Status:' || ${p_status};
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Other. Please check logs for details.');
    RAISE; -- Re-raise the exception for further handling
END;
/
EXIT;
EOF
)

sqlcl=/c/WinApp/oracle/sqlcl/bin/sql
dburl=david/alexgo12@192.168.1.2:1521/XE
echo "$sqlcl_script" | ${sqlcl} -s ${dburl}

#!/bin/bash

p_city=${1}
p_status=${2}

sqlcl_script=$(cat <<EOF

SET SERVEROUTPUT ON;

DECLARE
    c_direct_reports SYS_REFCURSOR;
    l_house_id house.id%TYPE;
    l_address  house.address%TYPE;
    l_city     house.city%TYPE;
    l_price    house.price%TYPE;
    v_count NUMBER := 0;

BEGIN

    -- Get the ref cursor from the function
    c_direct_reports := get_direct_reports('${p_city}');

    -- Process each record in cursor
    LOOP
        FETCH c_direct_reports INTO l_house_id, l_address, l_city, l_price;
        EXIT WHEN c_direct_reports%NOTFOUND;

        -- Your processing logic here (e.g., display House details)
        DBMS_OUTPUT.PUT_LINE('House ID: ' || l_house_id);
        DBMS_OUTPUT.PUT_LINE('Address: ' || l_address);
        DBMS_OUTPUT.PUT_LINE('City: ' || l_city);
	DBMS_OUTPUT.PUT_LINE('Price: ' || l_price);

	v_count := v_count + 1 ;
    END LOOP;

    DBMS_OUTPUT.PUT_LINE('Total count: ' || v_count);

EXCEPTION
  -- Handle potential exceptions
  WHEN NO_DATA_FOUND THEN
    DBMS_OUTPUT.PUT_LINE('Data Not Found Error: ${p_city}' );

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


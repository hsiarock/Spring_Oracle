#!/bin/bash

sqlcl=/c/WinApp/oracle/sqlcl/bin/sql
dburl=david/alexgo12@192.168.1.2:1521/XE

# doesn't work!
# ${sqlcl} -s ${dburl} ${sqlcl_script} 

${sqlcl} -s ${dburl} << EOF


    SET SERVEROUTPUT ON
    EXEC LIST_HOUSE_JSON();
    COMMIT;

    SET PAGESIZE 0
    SET LONG 1000000
    SET LONGCHUNKSIZE 1000000

    SELECT ID, DATE_LOADED, PO_DOCUMENT
       FROM SAMPLE_JSON_TABLE;

EXIT;
EOF



-- output json string from table HOUSE
SELECT JSON_OBJECT(*)
  FROM HOUSE
  WHERE price > 900000

SELECT JSON_OBJECT(Address, City, State, Zip, Price, Bed, Bath, SQFT, HOV, Credatetime)
  FROM HOUSE 
    WHERE Price > 1000000

-- use JOIN
SELECT JSON_OBJECT('NAME' VALUE first_name, d.*)
FROM employees e, departments d
WHERE e.department_id = d.department_id
AND e.employee_id =140

-- convert the whole table to one signe JSON string
SELECT JSON_ARRAYAGG(JSON_OBJECT(*))
FROM house

-- The following statement creates table sample_json_table. 
-- Column po_document is for storing JSON data and, 
-- therefore, has an IS JSON check constraint to ensure that only well-formed JSON is stored in the column.

CREATE TABLE sample_json_table (
    id RAW (16) NOT NULL,
    date_loaded TIMESTAMP(6) WITH TIME ZONE,
    po_document CLOB CONSTRAINT ensure_json CHECK (po_document IS JSON)
);

-- check insert_clob_json.sql for INSERT INTO sample_json_table

-- use JSON_QUEFRY_CLAUSE
SELECT st.phones
FROM SAMPLE_JSON_TABLE,
JSON_TABLE(po_document, '$.ShippingInstructions'
COLUMNS
  (phones VARCHAR2(100) FORMAT JSON PATH '$.Phone')) AS st;

--[{"type":"Office","number":"909-555-7307"},{"type":"Mobile","number":"415-555-1234"}]

-- use JSON_VALUE_CLAUSE
SELECT st.*
FROM sample_json_table,
JSON_TABLE(po_document, '$.ShippingInstructions.Phone[*]'
COLUMNS (row_number FOR ORDINALITY,
         phone_type VARCHAR2(10) PATH '$.type',
         phone_num VARCHAR2(20) PATH '$.number'))
AS st;


-- HAS_IS
SELECT requestor, has_zip
FROM sample_json_table,
JSON_TABLE(po_document, '$'
COLUMNS
  (requestor VARCHAR2(32) PATH '$.Requestor',
   has_zip VARCHAR2(5) EXISTS PATH '$.ShippingInstructions.Address.zipCode'));

SELECT requestor
FROM sample_json_table,
JSON_TABLE(po_document, '$'
COLUMNS
  (requestor VARCHAR2(32) PATH '$.Requestor',
   has_zip VARCHAR2(5) EXISTS PATH '$.ShippingInstructions.Address.zipCode'))
WHERE (has_zip = 'true');

-- The following statement does not use the JSON_nested_path clause. 
-- It returns the three elements in the array in a single row. 
-- The nested array is returned in its entirety.
SELECT *
FROM JSON_TABLE('[1,2,["a","b"]]', '$'
COLUMNS (outer_value_0 NUMBER PATH '$[0]',
         outer_value_1 NUMBER PATH '$[1]', 
         outer_value_2 VARCHAR2(20) FORMAT JSON PATH '$[2]'));

--OUTER_VALUE_0 OUTER_VALUE_1 OUTER_VALUE_2
--------------- ------------- --------------------
--            1             2 ["a","b"]

--With NEST CLAUSE
SELECT *
FROM JSON_TABLE('[1,2,["a","b"]]', '$'
COLUMNS (outer_value_0 NUMBER PATH '$[0]',
         outer_value_1 NUMBER PATH '$[1]',
         NESTED PATH '$[2]'
         COLUMNS (nested_value_0 VARCHAR2(1) PATH '$[0]',
                  nested_value_1 VARCHAR2(1) PATH '$[1]')));

-- OUTER_VALUE_0 OUTER_VALUE_1 NESTED_VALUE_0 NESTED_VALUE_1
-- ------------- ------------- -------------- --------------
--             1             2 a              b

SELECT *
FROM JSON_TABLE('{a:100, b:200, c:{d:300, e:400}}', '$'
COLUMNS (outer_value_0 NUMBER PATH '$.a',
         outer_value_1 NUMBER PATH '$.b',
         NESTED PATH '$.c'
         COLUMNS (nested_value_0 NUMBER PATH '$.d',
                  nested_value_1 NUMBER PATH '$.e')));

-- OUTER_VALUE_0 OUTER_VALUE_1 NESTED_VALUE_0 NESTED_VALUE_1
-- ------------- ------------- -------------- --------------
--           100           200            300            400

SELECT st.*
FROM SAMPLE_JSON_TABLE,
JSON_TABLE(po_document, '$'
COLUMNS
  (requestor VARCHAR2(32) PATH '$.Requestor',
   NESTED PATH '$.ShippingInstructions.Phone[*]'
     COLUMNS (phone_type VARCHAR2(32) PATH '$.type',
              phone_num VARCHAR2(20) PATH '$.number')))
AS st;
 
 
-- REQUESTOR            PHONE_TYPE           PHONE_NUM
-- -------------------- -------------------- ---------------
-- Alexis Bull          Office               909-555-7307
-- Alexis Bull          Mobile               415-555-1234

SELECT c.*
FROM customer t,
JSON_TABLE(t.json COLUMNS(
    id, name, phone, address,
    NESTED orders[*] COLUMNS(
        updated, status,
        NESTED lineitems[*] COLUMNS(
            description, quantity NUMBER, price NUMBER
    )
    )
)) c;

--Below is the same NEXT CLAUSE but w/o dot notation
SELECT c.*
FROM customer t,
JSON_TABLE(t.json, '$' COLUMNS(
    id PATH '$.id',
    name PATH '$.name',
    phone PATH '$.phone',
    address PATH '$.address',
    NESTED PATH '$.orders[*]' COLUMNS(
        updated PATH '$.updated',
        status PATH '$.status',
        NESTED PATH '$.lineitems[*]' COLUMNS(
        description PATH '$.description',
        quantity NUMBER PATH '$.quantity',
        price NUMBER PATH '$.price'
    )
)
)) c;


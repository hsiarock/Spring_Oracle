CREATE OR REPLACE PROCEDURE export_house_data IS
  
  CURSOR house_cursor IS
    SELECT address, city, state, zip, price, bed, credatetime
     FROM House;
  
  house_rec house_cursor%ROWTYPE;
  v_json_array JSON_ARRAY_T := JSON_ARRAY_T();
  json_data CLOB;

BEGIN
  OPEN house_cursor;
  
  LOOP
    FETCH house_cursor INTO house_rec;
    EXIT WHEN house_cursor%NOTFOUND;

    -- Retrieve values from the cursor
    -- Add values to JSON array
    v_json_array.append(JSON_OBJECT(
        'address'   VALUE house_rec.address,
        'city'      VALUE house_rec.city,
        'state'     VALUE house_rec.state,
        'zip'       VALUE house_rec.zip,
        'price'     VALUE TO_CHAR(house_rec.price),
        'bed'       VALUE TO_CHAR(house_rec.bed),
        'creadatetime' VALUE TO_CHAR(house_rec.credatetime, 'YYYY-MM-DD HH24:MI:SS')));

  END LOOP;

    -- Convert the record to a JSON string
  --  json_data := TO_CLOB(TO_CHAR(json_object(
  --                            'address' VALUE house_rec.address,
  --                            'city' VALUE house_rec.city,
  --                            'state' VALUE house_rec.state,
  --                            'zip' VALUE house_rec.zip,
  --                            'price' VALUE TO_CHAR(house_rec.price),
  --                            'bed' VALUE TO_CHAR(house_rec.bed),
  --                            'creadatetime' VALUE TO_CHAR(house_rec.credatetime, 'YYYY-MM-DD HH24:MI:SS'))));
  
    DBMS_LOB.WRITEAPPEND(json_data, LENGTH(v_json_array.to_string), v_json_array.to_string);

    -- Insert the JSON string into the json_table
    INSERT INTO sample_json_table VALUES (SYS_GUID(), SYSTIMESTAMP, json_data);

   CLOSE house_cursor;
  
      -- Free the temporary CLOB
    DBMS_LOB.FREETEMPORARY(json_data);

  COMMIT;
EXCEPTION
  WHEN OTHERS THEN
    ROLLBACK;
    RAISE;

END export_house_data;
/
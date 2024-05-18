
SET SERVEROUTPUT ON;

DECLARE

    CURSOR house_cursor IS
        SELECT address, city, state, zip, price, bed, bath, sqft, hov, credatetime
            FROM House;

    house_rec house_cursor%ROWTYPE;
    v_clob CLOB := EMPTY_CLOB();
    v_json_array JSON_ARRAY_T := JSON_ARRAY_T();
    v_json_out VARCHAR2(4000);

    PROCEDURE DBMS_LOB;

BEGIN
    -- initialize the CLOB variable before using DBMS_LOB function
    --DBMS_LOB.CREATEINFINITELOB(v_clob, REPLACE => FALSE); -- replace if existing data
    DBMS_LOB.CREATETEMPORARY(v_clob, TRUE);
    DBMS_LOB.OPEN(v_clob, DBMS_LOB.LOB_READWRITE);
    -- Retrieve the JSON data from the CLOB column
    OPEN house_cursor;
    LOOP
        FETCH house_cursor INTO house_rec;
        EXIT WHEN house_cursor%NOTFOUND;

        --json_out := JSON_OBJECTAGG(JSON_OBJECT(*)) WITHIN GROUP (ORDER BY Id);

        -- Add values to JSON array
        v_json_out := JSON_OBJECT(
            'Address'   VALUE house_rec.address,
            'City'      VALUE house_rec.city,
            'State'     VALUE house_rec.state,
            'Zip'       VALUE house_rec.zip,
            'Price'     VALUE house_rec.price,
            'Bed'       VALUE house_rec.bed,
            'Bath'      VALUE house_rec.bath,
            'SQFT'      VALUE house_rec.sqft,
            'HOV'       VALUE house_rec.hov,
            'Credatetime' VALUE house_rec.credatetime
        );

        DBMS_OUTPUT.PUT_LINE('Query JSON object output: ' || v_json_out);
    
        -- Append the chunk to final array
       DBMS_LOB.append(v_clob, v_json_out);
        -- DBMS_LOB.APPEND(DEST_LOB  => v_clob /*IN OUT BLOB*/,
        --                 SRC_LOB  => v_json_out/*IN BLOB*/);
        
    END LOOP;
    CLOSE house_cursor;

    --DBMS_LOB.WRITEAPPEND(v_clob, LENGTH(v_json_array.to_string), v_json_array.to_string);

    -- Parse the JSON data
    --v_json_object := JSON_OBJECT_T.parse(v_clob);

    -- Get a value from the JSON object
    --v_address := v_json_object.get_string('Address');

    -- Output the value
    --DBMS_OUTPUT.PUT_LINE('Address: ' || v_myout);

    -- Free the temporary CLOB
    DBMS_LOB.FREETEMPORARY(v_clob);

    DBMS_OUTPUT.PUT_LINE('Done');
END;
/

CREATE OR REPLACE procedure list_house_json  as 
    l_count PLS_INTEGER := 0;
    -- Variables to hold query results
    v_address VARCHAR2(255);
    v_city VARCHAR2(255);
    v_state VARCHAR2(255);
    v_zip VARCHAR2(10);
    v_price VARCHAR2(10);
    v_bed VARCHAR2(10);
    v_bath VARCHAR2(10);
    v_sqft VARCHAR2(10);
    v_hov VARCHAR2(10);
    v_createdm VARCHAR2(100); -- HOUSE.CREDATETIME%TYPE;

    -- JSON array to store query results
    v_json_array JSON_ARRAY_T := JSON_ARRAY_T();
    v_clob CLOB;

    -- Cursor to hold the result of the query
    CURSOR c_house IS
        -- SQL query to execute
        SELECT Address, City, State, Zip, Price, Bed, Bath, SQFT, HOV, Credatetime 
        FROM HOUSE;

BEGIN

    --DBMS_OUTPUT.ENABLE(BUFFER_SIZE => NULL);
    -- Open the cursor
    -- Check if cursor is already open
    -- use below FOR .... LOOP oracle open cursor implicitly.
    -- so don't open cursor again
    -- IF c_house%ISOPEN THEN
    -- DBMS_OUTPUT.PUT_LINE('Close before re-open it');
    --     close c_house;
    -- END IF;
        
        -- OPEN c_house;
        -- DBMS_OUTPUT.PUT_LINE('Open the cursor successfully');
    
    -- Loop through each row in the result set
    FOR house_rec IN c_house LOOP
        -- Retrieve values from the cursor
        v_address := house_rec.Address;
        v_city := house_rec.City;
        v_state := house_rec.State;
        v_zip := house_rec.Zip;
        v_price := TO_CHAR(house_rec.Price);
        v_bed := TO_CHAR(house_rec.Bed);
        v_bath := TO_CHAR(house_rec.Bath);
        v_sqft := TO_CHAR(house_rec.SQFT);
        v_hov := TO_CHAR(house_rec.HOV);
        v_createdm := TO_CHAR(house_rec.Credatetime, 'YYYY-MM-DD HH24:MI:SS');

        -- Add values to JSON array
        v_json_array.append(JSON_OBJECT(
            'Address'   VALUE v_address,
            'City'      VALUE v_city,
            'State'     VALUE v_state,
            'Zip'       VALUE v_zip,
            'Price'     VALUE v_price,
            'Bed'       VALUE v_bed,
            'Bath'      VALUE v_bath,
            'SQFT'      VALUE v_sqft,
            'HOV'       VALUE v_hov,
            'Credatetime' VALUE v_createdm
        ));
        l_count := l_count + 1;
    END LOOP;
    
    -- Close the cursor
    -- CLOSE c_house;
    -- Convert the JSON array to a string and store it in the CLOB
    
    DBMS_LOB.WRITEAPPEND(v_clob, LENGTH(v_json_array.to_string), v_json_array.to_string);

    -- Insert the CLOB into the table
    INSERT INTO sample_json_table VALUES (SYS_GUID(), SYSTIMESTAMP, v_clob);

    -- Free the temporary CLOB
    DBMS_LOB.FREETEMPORARY(v_clob);

    -- Output the JSON array
    DBMS_OUTPUT.PUT_LINE(v_json_array.to_string);

EXCEPTION
  -- Handle potential exceptions
  WHEN NO_DATA_FOUND THEN
    DBMS_OUTPUT.PUT_LINE('No Data Found Error');

  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Other. Please check logs for details.');
    RAISE; -- Re-raise the exception for further handling

END list_house_json;
CREATE OR REPLACE procedure LIST_HOUSE_JSON
as 
l_count PLS_INTEGER := 0;
DECLARE
    -- Variables to hold query results
    v_address VARCHAR2(255);
    v_city VARCHAR2(255);
    v_state VARCHAR2(255);
    v_zip VARCHAR2(10);
    v_price NUMBER;
    v_bed NUMBER;
    v_bath NUMBER(3,1);
    v_sqft NUMBER;
    v_hov NUMBER;
    -- JSON array to store query results
    v_json_array JSON_ARRAY_T := JSON_ARRAY_T();
    -- Cursor to hold the result of the query
    CURSOR c_house IS
        -- SQL query to execute
        SELECT Address, City, State, Zip, Price, Bed, Bath, SQFT, HOV FROM HOUSE;
BEGIN
    -- Open the cursor
    OPEN c_house;
    
    -- Loop through each row in the result set
    FOR house_rec IN c_house LOOP
        -- Retrieve values from the cursor
        v_address := house_rec.Address;
        v_city := house_rec.City;
        v_state := house_rec.State;
        v_zip := house_rec.Zip;
        v_price := house_rec.Price;
        v_bed := house_rec.Bed;
        v_bath := house_rec.Bath;
        v_sqft := house_rec.SQFT;
        v_hov := house_rec.HOV;
        
        -- Add values to JSON array
        v_json_array.append(JSON_OBJECT(
            'Address' => v_address,
            'City' => v_city,
            'State' => v_state,
            'Zip' => v_zip,
            'Price' => v_price,
            'Bed' => v_bed,
            'Bath' => v_bath,
            'SQFT' => v_sqft,
            'HOV' => v_hov
        ));

        l_count := l_count + 1;
    END LOOP;
    
    -- Close the cursor
    CLOSE c_house;
    
    -- Output the JSON array
    DBMS_OUTPUT.PUT_LINE(v_json_array.to_string);
END;
/

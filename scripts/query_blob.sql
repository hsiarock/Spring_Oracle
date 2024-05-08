DECLARE
    v_clob CLOB;
    v_json_object JSON_OBJECT_T;
    v_address VARCHAR2(255);
BEGIN
    -- Retrieve the JSON data from the CLOB column
    SELECT json_data INTO v_clob FROM json_table WHERE id = 1;

    -- Parse the JSON data
    v_json_object := JSON_OBJECT_T.parse(v_clob);

    -- Get a value from the JSON object
    v_address := v_json_object.get_string('Address');

    -- Output the value
    DBMS_OUTPUT.PUT_LINE('Address: ' || v_address);
END;
/

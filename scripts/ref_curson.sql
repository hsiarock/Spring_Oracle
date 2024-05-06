DECLARE
    c_direct_reports SYS_REFCURSOR;
    l_house_id house.id%TYPE;
    l_address house.address%TYPE;
    l_city house.city%TYPE;
    l_price house.price%TYPE;
BEGIN
    -- Get the ref cursor from the function
    c_direct_reports := get_direct_reports('Alhambra');

    -- Process each employee
    LOOP
        FETCH c_direct_reports INTO l_house_id, l_address, l_city, l_price;
        EXIT WHEN c_direct_reports%NOTFOUND;

        -- Your processing logic here (e.g., display employee details)
        DBMS_OUTPUT.PUT_LINE('House ID: ' || l_house_id);
        DBMS_OUTPUT.PUT_LINE('Address: ' || l_address );
        DBMS_OUTPUT.PUT_LINE('City: ' || l_city);
        DBMS_OUTPUT.PUT_LINE('Price: ' || l_price);
    END LOOP;
END;
/

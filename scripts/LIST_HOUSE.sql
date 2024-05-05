CREATE OR REPLACE procedure list_house (
  p_city in varchar2, 
  p_status in varchar2,
  p_call_result out varchar2,
  p_count_out out NUMBER
) as 
 l_count PLS_INTEGER := 0;
BEGIN
  FOR house_rec IN (
        SELECT Address, city, state, zip, price 
         FROM house
         WHERE city = p_city AND status = p_status)
  LOOP
    p_call_result := house_rec.address || ',' || house_rec.city || ',' || house_rec.state || ',' ||
                     house_rec.zip || ',' || house_rec.price || ';' ;
    l_count := l_count + 1;

    -- DBMS_OUTPUT.PUT_LINE('Found: ' || house_rec.address || ', '
    --                       || house_rec.city || ', '
    --                       || house_rec.state|| ', '
    --                       || house_rec.zip|| ', '
    --                       || house_rec.price
    --                      );
  END LOOP;
  
  DBMS_OUTPUT.PUT_LINE('Total found : ' || l_count);
  p_call_result := p_call_result || 'Total count: ' || l_count;
  p_count_out := l_count;

  DBMS_OUTPUT.PUT_LINE('Return result: ' || p_call_result);

EXCEPTION
  -- Handle potential exceptions
  WHEN NO_DATA_FOUND THEN
    DBMS_OUTPUT.PUT_LINE('Found Error: ' || p_city || ' not found.');
    p_call_result := 'No Data Found for list City:' || p_city || ', Status:' || p_status;
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Other. Please check logs for details.');
    RAISE; -- Re-raise the exception for further handling
END list_house;
CREATE OR REPLACE FUNCTION get_direct_reports(
        in_city IN house.city%TYPE)
    RETURN SYS_REFCURSOR AS
    c_direct_reports SYS_REFCURSOR;
BEGIN
    OPEN c_direct_reports FOR
        SELECT id, address, city, price
        FROM house
        WHERE city = in_city
        ORDER BY price;

    RETURN c_direct_reports;
END;
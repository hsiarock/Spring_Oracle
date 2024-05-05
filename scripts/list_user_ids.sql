CREATE OR REPLACE PROCEDURE list_user_ids AS
BEGIN
  FOR user_rec IN (SELECT username FROM dba_users) LOOP
    DBMS_OUTPUT.PUT_LINE(user_rec.username);
  END LOOP;
END;
/
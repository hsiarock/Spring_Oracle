
#set ORACLE_SID=XE
#sqlplus / as sysdba

# this line working
sqlcl david/alexgo12 ---> use DAVID id

SELECT * from DBA_USERS where username like 'DAV%';
    default_tablespace=USERS
    Temp_tablespace=TEMP
SELECT * FROM ALL_USERS where USERNAME like 'APEX%';
SELECT ROLE FROM DBA_ROLES where ROLE like 'ORDS%';

#undocumented/hindent parameter before create user
ALTER SESSION SET "_ORACLE_SCRIPT"=true;
DROP USER david
CREATE USER david IDENTIFIED BY alexgo12; DEFAULT ROLE RESOURCE; # no double quote, so save as all upper case
# only when with lowser case or mix-case and you want to keep it exactly, use double quote
GRANT CREATE SESSION, CONNECT, RESOURCE, CREATE TABLE, CREATE TYPE, SELECT_CATALOG_ROLE, JAVAUSERPRIV, JAVAIDPRIV, JAVASYSPRIV, JAVADEBUGPRIV, JAVA_ADMIN TO david;
# above command grant DAVID id with the create session and connect....etc
# for Java Stored Procedure you must have the following priviliages
GRANT CREATE PROCEDURE, CREATE ANY PROCEDURE, CREATE ANY TABLE TO david;
GRANT oracle.aurora.security.JServerPermission.loadLibraryInClass.classname TO david;
GRANT ission.loadLibraryInClass.classname TO david;

# grant procedure EXEC 
desc dba_tab_privs
SELECT grantee, privilege
    FROM dba_tab_privs
    WHERE table_name = 'LIST_HOUSE'  -- Replace with actual procedure name
    AND schema_name = 'DAVID';  -- Replace with schema name if needed

GRANT EXECUTE ON PROCEDURE LIST_HOUSE TO david;

ALTER USER SYS ACCOUNT UNLOCK;  #Remember to lock the SYS user when the installation is complete.
ALTER USER SYS ACCOUNT LOCK;

SELECT owner, table_name, privilege FROM role_tab_privs WHERE role = 'SALES_CLERK';

# reset password
ALTER USER "david" IDENTIFIED BY alexgo12;

# check user's tablespace name
SELECT tablespace_name, block_size, initial_extent, next_extent, status 
  FROM user_tablespaces;

# list all objects for specific tablespace
SELECT * FROM dba_segments 
  WHERE TABLESPACE_NAME = 'USERS' ORDER BY bytes DESC;

# to check user id
SELECT username, default_tablespace, temporary_tablespace
  FROM dba_users
  WHERE username = 'DAVID';

# allocate quota to user DAVID  -> don't put the single/double quote around DAVID
ALTER USER DAVID QUOTA UNLIMITED ON USERS;

# check java schema
SELECT dbms_java.longname(object_name) FROM user_objects WHERE object_type = 'JAVA RESOURCE';
SELECT * from javasnm;


select * from DBMS_JAVA.JAVA$OPTIONS;
SELECT SYS_CONTEXT('USERENV', 'CURRENT_SCHEMA') AS current_schema FROM DUAL;


SELECT Address, city, state, zip, price, status FROM house;

DECLARE
l_call_result out VARCHAR2;
BEGIN
   call list_house('Alhambra', 'Active', l_call_result);
END;
/



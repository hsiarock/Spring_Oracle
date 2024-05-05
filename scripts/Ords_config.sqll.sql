#ORDS_METADATA
#ORDS_PUBLIC_USER
SELECT * from DBA_USERS where username like 'APEX%';
SELECT * FROM ALL_USERS where USERNAME like 'APEX%';
SELECT * from DBA_USERS where username like 'ORDS%';

# for APEX
SELECT tablespace_name FROM dba_tablespaces; # core=SYSAUX, file=UNDOTBS1, temp=TEMP, 
# dosplay name and location of the server parameter file or initial parameter file
SQL> show parameter pfile; 
show parameter pfile;
NAME   TYPE   VALUE
------ ------ -----------------------------------
spfile string E:\ORACLE\21C\DATABASE\SPFILEXE.ORA

SQL> SHOW PARAMETER MEMORY_TARGET





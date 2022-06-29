#!bin/bash
#This script will excute a sql in many databases, it needs some improvements on user and pass case it is not the same for all dbs

for env in DB1 DB2 DBN
    do 
    n='1'
    export ORACLE_SID=$env$n
    export ORACLE_ASK=NO
    . oraenv
    sqlplus -S USER/PASS@$env @sqlscriptname.sqlplus
done

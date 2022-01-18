#!/bin/bash

echo "Count from mysql_master:"
docker exec mysql_master sh -c "export MYSQL_PWD=mydb_pwd; mysql -u mydb_user -D mydb -e 'SELECT count(*) FROM users;'"

echo "Count from mysql_slave1:"
docker exec mysql_slave1 sh -c "export MYSQL_PWD=mydb_slave1_pwd; mysql -u mydb_slave1_user -D mydb -e 'SELECT count(*) FROM users;'"

echo "Count from mysql_slave2:"
docker exec mysql_slave2 sh -c "export MYSQL_PWD=mydb_slave2_pwd; mysql -u mydb_slave2_user -D mydb -e 'SELECT count(*) FROM users;'"

#!/bin/bash

echo "=================== Testing the replication ===================="

echo "Creating Table..."
create_table_cmd='CREATE TABLE users (id int NOT NULL AUTO_INCREMENT, username VARCHAR(100),  password VARCHAR(100), age INT, PRIMARY KEY (id)) ENGINE=InnoDB; '
docker exec mysql_master sh -c "export MYSQL_PWD=mydb_pwd; mysql -u mydb_user -D mydb -e '$create_table_cmd'"

echo "Inserting data..."
insert_cmd="INSERT INTO users (username, password, age) VALUES ('Darth Vader', 'death star', 50);"
insert_cmd+="INSERT INTO users (username, password, age) VALUES ('Luke Skywalker', 'sdfdfsdf', 25);"
insert_cmd+="INSERT INTO users (username, password, age) VALUES ('Chewbakka', 'rrraarGhhrraarr', 123);"
insert_cmd+="INSERT INTO users (username, password, age) VALUES ('R2D2', 'peep-peeep', 444);"
insert_master_cmd='export MYSQL_PWD=mydb_pwd; mysql -u mydb_user -D mydb -e "'
insert_master_cmd+="$insert_cmd"
insert_master_cmd+='"'
docker exec mysql_master sh -c "$insert_master_cmd"

echo "Data on mysql_master:"
docker exec mysql_master sh -c "export MYSQL_PWD=mydb_pwd; mysql -u mydb_user -D mydb -e 'SELECT * FROM users;'"

echo "Data on mysql_slave1:"
docker exec mysql_slave1 sh -c "export MYSQL_PWD=mydb_slave1_pwd; mysql -u mydb_slave1_user -D mydb -e 'SELECT * FROM users;'"

echo "Data on mysql_slave2:"
docker exec mysql_slave2 sh -c "export MYSQL_PWD=mydb_slave2_pwd; mysql -u mydb_slave2_user -D mydb -e 'SELECT * FROM users;'"

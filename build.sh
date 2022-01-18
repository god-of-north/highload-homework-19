#!/bin/bash

docker-compose down
rm -rf ./master/data/*
rm -rf ./slave1/data/*
rm -rf ./slave2/data/*
docker-compose build
docker-compose up -d

until docker exec mysql_master sh -c 'export MYSQL_PWD=111; mysql -u root -e ";"'
do
    echo "Waiting for mysql_master database connection..."
    sleep 4
done

echo "============ Configuring mysq_master for replication ==========="
priv_stmt='GRANT REPLICATION SLAVE ON *.* TO "mydb_slave1_user"@"%" IDENTIFIED BY "mydb_slave1_pwd"; FLUSH PRIVILEGES;GRANT REPLICATION SLAVE ON *.* TO "mydb_slave2_user"@"%" IDENTIFIED BY "mydb_slave2_pwd"; FLUSH PRIVILEGES;'
docker exec mysql_master sh -c "export MYSQL_PWD=111; mysql -u root -e '$priv_stmt'"

until docker-compose exec mysql_slave1 sh -c 'export MYSQL_PWD=111; mysql -u root -e ";"'
do
    echo "Waiting for mysql_slave1 database connection..."
    sleep 4
done

until docker-compose exec mysql_slave2 sh -c 'export MYSQL_PWD=111; mysql -u root -e ";"'
do
    echo "Waiting for mysql_slave2 database connection..."
    sleep 4
done

docker-ip() {
    docker inspect --format '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' "$@"
}

MS_STATUS=`docker exec mysql_master sh -c 'export MYSQL_PWD=111; mysql -u root -e "SHOW MASTER STATUS"'`
CURRENT_LOG=`echo $MS_STATUS | awk '{print $6}'`
CURRENT_POS=`echo $MS_STATUS | awk '{print $7}'`

echo "============== Starting replica on mysql_slave1 ================"
start_slave1_stmt="CHANGE MASTER TO MASTER_HOST='$(docker-ip mysql_master)',MASTER_USER='mydb_slave1_user',MASTER_PASSWORD='mydb_slave1_pwd',MASTER_LOG_FILE='$CURRENT_LOG',MASTER_LOG_POS=$CURRENT_POS; START SLAVE;"
start_slave1_cmd='export MYSQL_PWD=111; mysql -u root -e "'
start_slave1_cmd+="$start_slave1_stmt"
start_slave1_cmd+='"'
docker exec mysql_slave1 sh -c "$start_slave1_cmd"

docker exec mysql_slave1 sh -c "export MYSQL_PWD=111; mysql -u root -e 'SHOW SLAVE STATUS \G'"

echo "=============== Starting replica on mysql_slave2 ==============="
start_slave2_stmt="CHANGE MASTER TO MASTER_HOST='$(docker-ip mysql_master)',MASTER_USER='mydb_slave2_user',MASTER_PASSWORD='mydb_slave2_pwd',MASTER_LOG_FILE='$CURRENT_LOG',MASTER_LOG_POS=$CURRENT_POS; START SLAVE;"
start_slave2_cmd='export MYSQL_PWD=111; mysql -u root -e "'
start_slave2_cmd+="$start_slave2_stmt"
start_slave2_cmd+='"'
docker exec mysql_slave2 sh -c "$start_slave2_cmd"

docker exec mysql_slave2 sh -c "export MYSQL_PWD=111; mysql -u root -e 'SHOW SLAVE STATUS \G'"



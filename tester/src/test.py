import os
import  json
from socket import timeout
from time import sleep
from datetime import datetime
import mysql.connector
from generator import Generator
import threading
from random import randint

def create_table():
    with mysql.connector.connect(host="mysql_master", user="mydb_user", password="mydb_pwd", database="mydb") as db:
        with db.cursor() as cursor:
            cursor.execute('DROP TABLE IF EXISTS users;')
            cursor.execute('CREATE TABLE IF NOT EXISTS users (user_id BIGINT AUTO_INCREMENT PRIMARY KEY, birth_day DATE, registration_date DATE, user_login VARCHAR(255) NOT NULL, user_email VARCHAR(255) NOT NULL, firstname VARCHAR(255) NOT NULL, surname VARCHAR(255) NOT NULL, patronymic VARCHAR(255) NOT NULL, sex VARCHAR(32), job_position VARCHAR(255) NOT NULL, description TEXT)  ENGINE=InnoDB;')
        db.commit()

def generate(count:int):
    with mysql.connector.connect(host="mysql_master", user="mydb_user", password="mydb_pwd", database="mydb") as db:
        gen = Generator()
        n = 1
        for i in range(count):
            user = gen.generate_user()

            sql = "INSERT INTO users (birth_day,registration_date,user_login,user_email,firstname,surname,patronymic,sex,job_position,description) VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s)"
            val = (user["birth"], user["reg"], user["login"], user["mail"], user["name"], user["surname"], user["patronymic"], user["sex"], user["job"], user["descr"])

            print(user["login"], user["name"], user["surname"], user["mail"], flush=True)

            cursor = db.cursor()
            cursor.execute(sql, val)

            db.commit()
            sleep(0.5)

def get_count(host, user, password):
    try:
        with mysql.connector.connect(host=host, user=user, password=password, database="mydb") as db:
            with db.cursor() as cursor:
                cursor.execute('SELECT count(*) FROM users;')
                result = cursor.fetchall()
                for row in result:
                    print(host, 'count:', row)
    except:
        print(host, 'DOWN')

def stat():
    while True:
        sleep(5)
        get_count(host="mysql_master", user="mydb_user", password="mydb_pwd")
        get_count(host="mysql_slave1", user="mydb_slave1_user", password="mydb_slave1_pwd")
        get_count(host="mysql_slave2", user="mydb_slave2_user", password="mydb_slave2_pwd")


create_table()
t = threading.Thread(target = stat, daemon = True)
t.start()
generate(1000)

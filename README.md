# highload-homework-19

**Set up MySQL Cluster**

- Create 3 docker containers: mysql-m, mysql-s1, mysql-s2
- Setup master slave replication (Master: mysql-m, Slave: mysql-s1, mysql-s2)
- Write script that will frequently write data to database
- Ensure, that replication is working
- Try to turn off mysql-s1, 
- Try to remove a column in  database on slave node

## Installaton

```
git clone https://github.com/god-of-north/highload-homework-19.git
cd highload-homework-19
./build.sh
```

## Testing & Results

### Ensure, that replication is working

```
$ ./test.sh
=================== Testing the replication ====================
Creating Table...
Inserting data...

Data on mysql_master:
id      username        password        age
1       Darth Vader     death star      50
2       Luke Skywalker  sdfdfsdf        25
3       Chewbakka       rrraarGhhrraarr 123
4       R2D2    peep-peeep      444

Data on mysql_slave1:
id      username        password        age
1       Darth Vader     death star      50
2       Luke Skywalker  sdfdfsdf        25
3       Chewbakka       rrraarGhhrraarr 123
4       R2D2    peep-peeep      444

Data on mysql_slave2:
id      username        password        age
1       Darth Vader     death star      50
2       Luke Skywalker  sdfdfsdf        25
3       Chewbakka       rrraarGhhrraarr 123
4       R2D2    peep-peeep      444
```

### Try to turn off mysql-s1

```
$ docker exec mysql_tester sh -c "python /src/test.py"
...
Eve3270 Eve Bennett Ansell1165@blablabla.org
Lorenzo1848 Lorenzo Wilson Wilson4828@blablabla.org
mysql_master count: (16,)
mysql_slave1 count: (16,)
mysql_slave2 count: (16,)
Alberg1722 Theodore Carter Carter2120@super-mail.net
...
Miller3886 Miller Cook Blohm242@blablabla.org
mysql_master count: (31,)
mysql_slave1 DOWN
mysql_slave2 count: (31,)
Bucky4374 Bucky Phillips Phillips148@blablabla.org
...
Delcy1930 Delcy Bennett Bennett540@gmail.com
mysql_master count: (136,)
mysql_slave1 count: (26,)
mysql_slave2 count: (136,)
Grant124 Grant Martin Martin940@blablabla.org
...
Lee4207 Desha Lee Ahl4387@spider.man
mysql_master count: (149,)
mysql_slave1 count: (100,)
mysql_slave2 count: (149,)
Wood3075 Prim Wood Wood820@super-mail.net
...
Yvonne3374 Yvonne Young Young3494@super-mail.net
mysql_master count: (162,)
mysql_slave1 count: (162,)
mysql_slave2 count: (163,)
Hall794 Fitz Hall Fitz2283@super-mail.net
...
```

### Try to remove a column in database on slave node

```
$ docker exec mysql_tester sh -c "python /src/test.py"
...
Beckius4001 Lydia Cook Lydia4724@death-star.net
mysql_master count: (33,)
mysql_slave1 count: (33,)
mysql_slave2 count: (33,)
Backlund2125 Grace/Gracie Cook Cook2339@blablabla.org
...
... <-- docker exec mysql_slave1 sh -c "export MYSQL_PWD=mydb_slave1_pwd; mysql -u mydb_slave1_user -D mydb -e 'ALTER TABLE users DROP COLUMN patronymic;'"
...
Beckstrand2609 Ethan Robinson Beckstrand3156@super-mail.net
mysql_master count: (41,)
mysql_slave1 count: (34,)
mysql_slave2 count: (41,)
Jones2650 Miles Jones Andre94@death-star.net
...
Carter2098 Andrew Carter Andrew2301@blablabla.org
mysql_master count: (58,)
mysql_slave1 count: (34,)
mysql_slave2 count: (58,)
Jackson2004 Liam Jackson Jackson3635@super-mail.net
...
Martin4876 Jesus Martin Jesus1778@spider.man
mysql_master count: (66,)
mysql_slave1 count: (34,)
mysql_slave2 count: (66,)
Lee3895 Joyce Lee Lee3493@spider.man
...
```
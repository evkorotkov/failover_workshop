# MySQL

### Initialization
```bash
docker compose exec -i -T mysql_1 mysql -uroot -proot < ./init_primary.sql
docker compose exec -i -T mysql_2 mysql -uroot -proot < ./init_secondary.sql
docker compose exec -i -T mysql_3 mysql -uroot -proot < ./init_secondary.sql
```

### Steps:
1. Run client
```bash
docker compose up -d
ruby client.rb
```

2. Connect to database
```bash
docker compose exec -it mysql_1 bash
mysql -uroot -proot
```

3. Check replication status
```mysql
SELECT Host,User FROM mysql.user;

show master status\G
show replica status\G
```

4. Simulate outage of mysql_1
```bash
dco down -d mysql_1
```

5. Start failover

- Update mysql config
- Connect to mysql_2

```mysql
STOP REPLICA;
SET GLOBAL read_only = 0;
```

6. Start replication on mysql_1

```bash
docker compose up -d mysql_1
docker compose exec -it mysql_1 bash
mysql -uroot -proot
```

```mysql
SET GLOBAL read_only = ON;

CHANGE REPLICATION SOURCE TO
  SOURCE_HOST = 'mysql_2',
  SOURCE_PORT = 3306,
  SOURCE_USER = 'replica',
  SOURCE_PASSWORD = 'replica',
  SOURCE_AUTO_POSITION = 1;

START REPLICA;
```

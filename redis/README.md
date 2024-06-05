# Redis

### Steps:

1. Run client
```bash
docker compose up -d
ruby client.rb
```

2. Simulate outage of redis_1
```bash
docker compose down redis_1
docker compose up -d redis_1
```

3. Monitoring sentinel
```bash
dco exec -it redis_sentinel_1 bash

redis-cli -p 26379 SENTINEL get-master-addr-by-name redis-group
redis-cli -p 26379 SENTINEL sentinels redis-group
redis-cli -p 26379 SENTINEL failover redis-group
```

4. Monitoring redis
```bash
dco exec -it redis_1 bash

redis-cli -a redis llen users

redis-cli -a redis info | grep role
redis-cli -a redis INFO REPLICATION
```


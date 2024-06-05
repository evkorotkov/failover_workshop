# Memcached

### Steps:

1. Run client
```bash
docker compose up -d
ruby client.rb
```

2. Simulate outage of memcached_1
```bash
docker compose down memcached_1
docker compose up -d memcached_1
```

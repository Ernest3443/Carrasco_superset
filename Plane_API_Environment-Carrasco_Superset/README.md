# Plane API Environment

## Set Up

Open terminal and navigate to preferred clone directory location
```bash
 git clone https://github.com/ShOC-N-BI/Plane_API_Environment.git
 
 docker-compose up -d
```
## Shut down

Open terminal and navigate to clone directory location
```bash
 docker-compose down
```

# Containers

| container | location | username | password | 
| :-------- | :------- | :------- | :------- |
| Grafana | http://localhost:3000/ | admin | admin |
| pgAdmin | http://localhost:3031/ | shoc@shoc.us | JustKeepSwimming |
| Postgres | http://localhost:5432/ | shoc | JustKeepSwimming |
| Nifi | http://localhost:8443/ | n/a | n/a |

## Notes

Connecting pgAdmin to Postgres
1. go to pgAdmin location
2. "add new server"
3. host = pg_container
4. enter username and pass

Connecting Grafana to Postgres
1. go to Grafana location
2. data sources 
3. add data source
4. PostgreSQL
5. host = pg_container
7. enter username and pass
8. enter previously created database name
9. TLS/SSL Mode = disable
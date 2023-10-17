#!/bin/bash
# A bash script to call the the postgres database and execute the loki injest script
psql --dbname=test_db --username=postgres --file=/home/postgres/loki-insert.sql
SELECT version();

docker exec -it 2-database-replication-db-1 psql -U postgres

\l

\c postgres

\d - look for tables

\d towns

SELECT * FROM towns LIMIT 5;

// Ensure you are in the correct prompt for SQL commands
postgres=# SELECT count(*) FROM towns;

// Switch to the correct database before creating the role
\c postgres

CREATE ROLE replica_user WITH REPLICATION LOGIN PASSWORD 'replic12';

2-database-replication-db-secondary-1

docker exec -it 2-database-replication-db-secondary-1 psql -U postgres

docker exec -it 2-database-replication-db-primary-1 psql -U postgres

https://hevodata.com/learn/postgresql-streaming-replication/

Start-BitsTransfer -Source "https://github.com/docker/compose/releases/download/v2.30.3/docker-compose-windows-x86_64.exe" -Destination $Env:ProgramFiles\Docker\docker-compose.exe

// Insert 1 million random records into the towns table, handling duplicates
INSERT INTO towns (code, article, name, department)
SELECT LEFT(md5(i::text), 10), md5(random()::text), md5(random()::text), LEFT(md5(random()::text), 4)
FROM generate_series(1, 1000000) s(i)
ON CONFLICT (code) DO NOTHING;

// To delete the replication role
\c postgres

DROP ROLE IF EXISTS replication_user;

// To modify the pg_hba.conf file using Docker commands
// 1. Locate the container ID or name of your PostgreSQL container:
docker ps

// 2. Copy the pg_hba.conf file from the container to your host:
docker cp <container_id>:/var/lib/postgresql/data/pg_hba.conf ./pg_hba.conf

// 3. Open the pg_hba.conf file in a text editor and add the following line:
host    replication     replication_user    0.0.0.0/0    md5

// 4. Save the file and copy it back to the container:
docker cp ./pg_hba.conf <container_id>:/var/lib/postgresql/data/pg_hba.conf

// 5. Reload the PostgreSQL configuration:
docker exec -it <container_id> psql -U postgres -c "SELECT pg_reload_conf();"

// To modify the postgresql.conf file
// 1. Locate the container ID or name of your PostgreSQL container:
docker ps

// 2. Copy the postgresql.conf file from the container to your host:
docker cp <container_id>:/var/lib/postgresql/data/postgresql.conf ./postgresql.conf

// 3. Open the postgresql.conf file in a text editor and add or modify the following lines:
wal_level = logical
wal_log_hints = on
max_wal_senders = 8
max_wal_size = 1GB
hot_standby = on

// 4. Save the file and copy it back to the container:
docker cp ./postgresql.conf 2-database-replication-db-primary-1:/var/lib/postgresql/data/postgresql.conf

// 5. Reload the PostgreSQL configuration:
docker exec -it 2-database-replication-db-primary-1 psql -U postgres -c "SELECT pg_reload_conf();"

wal_level = logical
wal_log_hints = on
max_wal_senders = 8
max_wal_size = 1GB
hot_standby = on

PS C:\dev\system-design\2-database-replication> docker cp 2-database-replication-db-primary-1:/var/lib/postgresql/data/postgresql.conf ./postgresql.conf

PS C:\dev\system-design\2-database-replication> docker cp 2-database-replication-db-secondary-1:/var/lib/postgresql/data/postgresql.conf ./postgresql.conf

docker cp ./postgresql.conf 2-database-replication-db-primary-1:/var/lib/postgresql/data/postgresql.conf

docker cp 2-database-replication-db-primary-1:/var/lib/postgresql/data/pg_hba.conf ./pg_hba.conf

docker cp ./pg_hba.conf 2-database-replication-db-primary-1:/var/lib/postgresql/data/pg_hba.conf

host replication replication_user 172.20.0.9 md5

Slave node

// To create a base backup of the master database
// Replace <data_directory>, <master_ip>, <port>, and <rep_user> with appropriate values
pg_basebackup -D /var/lib/postgresql/data -h <primary_db_ip> -p <port> -X stream -c fast -U replication_user -W

// If pg_basebackup is missing, install it using the following command:
// For Debian/Ubuntu:
sudo apt-get install postgresql-client

// For Red Hat/CentOS:
sudo yum install postgresql

// For Alpine:
sudo apk add postgresql-client

// For Windows:
// 1. Download the PostgreSQL installer from https://www.postgresql.org/download/windows/
// 2. Run the installer and select the components you need, including pg_basebackup
// 3. Follow the installation instructions to complete the setup

C:\Program Files\PostgreSQL\16\bin path environmental variables

docker ps

SELECT rolname, rolsuper, rolreplication
FROM pg_roles
WHERE rolname = 'replication_user';


pg_ctl restart -D /var/lib/postgresql/data 

Steraming - Primary changes
listen_addresses = '*'
archive_mode = on
max_wal_senders = 5 
max_wal_size = 10GB    
wal_level = replica
hot_standby = on   
archive_command = 'rsync -a %p /opt/pg_archives/%f'


SELECT * FROM pg_stat_replication;

ENTER DOCKER BASH
docker exec -it a6c25573bdc7b361f304394eeac0a190f44b2409c8cdd4d9f9709b87bf4c5f25 /bin/bash

su postgres

docker exec -it db34f42365a7dfdb248aa14aa234897a6afb0d4d0b85d9f4df9ff8065936ab54 /bin/ba


pg_ctl restart -D /var/lib/postgresql/data

a6c25573bdc7b361f304394eeac0a190f44b2409c8cdd4d9f9709b87bf4c5f25

docker exec a6c25573bdc7b361f304394eeac0a190f44b2409c8cdd4d9f9709b87bf4c5f25 mkdir -p /var/lib/postgresql/data/pg_archives 

/ $ pg_basebackup -h 172.23.240.1 -U replicator -p 5433 -D $PGDATA -P -Xs -R
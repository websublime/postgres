#!/bin/bash
set -e

echo "host replication $POSTGRES_USER 0.0.0.0/0 trust" >> $PGDATA/pg_hba.conf
echo "shared_preload_libraries = 'pg_stat_statements, pgaudit, plpgsql, plpgsql_check, pg_cron, decoderbufs, wal2json'" >> $PGDATA/postgresql.conf
echo "pg_stat_statements.max = 10000" >> $PGDATA/postgresql.conf
echo "pg_stat_statements.track = all" >> $PGDATA/postgresql.conf
echo "wal_level=logical" >> $PGDATA/postgresql.conf
echo "max_replication_slots=4" >> $PGDATA/postgresql.conf
echo "max_wal_senders=4" >> $PGDATA/postgresql.conf
echo "log_destination='csvlog'" >> $PGDATA/postgresql.conf
echo "logging_collector=on" >> $PGDATA/postgresql.conf
echo "log_filename='postgresql.log'" >> $PGDATA/postgresql.conf
echo "log_rotation_age=0" >> $PGDATA/postgresql.conf
echo "log_rotation_size=0" >> $PGDATA/postgresql.conf
echo "cron.database_name='postgres'" >> $PGDATA/postgresql.conf
echo "jwt.secret='$JWT_SECRET'" >> $PGDATA/postgresql.conf
echo "jwt.courier_url='$COURIER_URL'" >> $PGDATA/postgresql.conf
echo "http.timeout_msec=60000" >> $PGDATA/postgresql.conf
echo "pljava.libjvm_location = '/usr/lib/jvm/java-11-openjdk-amd64/lib/server/libjvm.so'" >> $PGDATA/postgresql.conf

pg_ctl restart

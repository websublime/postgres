# POSTGRES DOCKER IMAGE

This is postgres image database with lot some essential plugins installed. Also as distributed event solution which can be played with [courier](https://github.com/websublime/courier) app.

List of plugins:

 - pgcron
 - postgis
 - pgtap
 - pgAudit
 - pgjwt
 - pgsql-http
 - plpgsql_check
 - pg-safeupdate
 - pljava
 - postgres-decoderbufs
 - wal2json

All extensions are activated on extensions namespace. Scripts in this repo are copied to image itself, but if you mount volume to `docker-entrypoint-initdb.d` they will be overrided. Copy this if you intend to add your scripts. Take a look on it to know that roles, extensions and courier functions are added.

This image also as some default environment values that you should check. All known for postgres, and two particular for use with [courier](https://github.com/websublime/courier).

```bash
POSTGRES_PORT="5432"
POSTGRES_USER="postgres"
POSTGRES_PASSWORD="postgres"

JWT_SECRET="3EK6FD+o0+idjh8sdfuihfsf89fjb23jnsdkjhsd8sjhsd8we2"
COURIER_URL="http://localhost:8883"
```

[Courier](https://github.com/websublime/courier) accepts post from postgres to publish events. If you want to use it you will have a trigger function where you can use on your database tables
to trigger to courier.

```sql
CREATE  TABLE "courier".audiences (
	id                   uuid NOT NULL ,
	name                 varchar(255)   ,
	created_at           timestamptz DEFAULT current_timestamp  ,
	updated_at           timestamptz DEFAULT current_timestamp  ,
	deleted_at           timestamptz  DEFAULT NULL ,
	CONSTRAINT pk_audience PRIMARY KEY ( id )
 );

 CREATE TRIGGER on_audiences_handler
  AFTER INSERT OR UPDATE OR DELETE ON "courier".audiences 
  FOR EACH ROW EXECUTE PROCEDURE extensions.notify_hook();
```

# DOCKER

How to use with docker

### BUILD

````
docker build --tag websublime/postgres --tag websublime/postgres:v1.1 .
````
### PUBLISH

````
docker image push --all-tags websublime/postgres
````

### RUN

```
docker-compose up -d --build
```

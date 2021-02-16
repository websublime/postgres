### BUILD

````
docker build --tag websublime/postgres --tag websublime/postgres:v1.1 .
````
### PUBLISH

````
docker image push --all-tags websublime/postgres
````

### RUN

````
docker-compose up -d --build
```

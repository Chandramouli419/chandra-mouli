# To test local Postgres database

## 1 Pre-Requisites:
### Docker Desktop license
1. Go to the [Help Desk portal](https://servicedesk.stonex.com/sp?id=index)
2. Select "REQUEST SOMETHING"
3. Select "Software Installation"

| Parameter                | Values |
|--------------------------|-------------|
| Select standard software | Docker Desktop |
| Requested action | Install (If you already have the free version installed, select "I only need the license") |
| Who is this for? | Individual distribution (one person) |
| Business justification | I need Docker Desktop to test PostGres databases locally. |

### Installation
 - [Docker Desktop](https://docs.docker.com/desktop/install/windows-install/)
 - [Postgres](https://www.postgresql.org/download/windows/)

## 2 Connect to the local Postgres server
You can use either PSQL client or the GUI pgAdmin
 - [PSQL or pgAdmin](https://www.enterprisedb.com/postgres-tutorials/connecting-postgresql-using-psql-and-pgadmin)

### PSQL Client
[Example Tutorial](https://www.geeksforgeeks.org/postgresql-connect-and-access-a-database/)

  - In windows search, type psql
  - In each prompt, until you get to "Password for user postgres", press enter.
  - Then at the password, type in your superuser password
  - [Common PSQL client commands](./PSQL-commands.md)

## 3 Create a User
```
CREATE ROLE liquibasetestuserlocal LOGIN PASSWORD 'my_password';
```

## 4 Create a Database

```
CREATE DATABASE "liquibaseTestDblocal" WITH 
                              OWNER = liquibasetestuserlocal
                              ENCODING = 'UTF8'
                              CONNECTION LIMIT = -1;
```
- You can double check the created database with  SELECT datname FROM pg_database;

## 5 Run local Instance
Note: pgAdmin is not enough to run the database. It will not allow communication.

- Execute from this directory the following command targeting the local instance of Postgres.

```
docker build --rm \
             --build-arg DATABASE_CONNECTION_STRING="jdbc:postgresql://host.docker.internal:5432/liquibaseTestDblocal" \
             --build-arg DATABASE_USERNAME="liquibasetestuserlocal" \
             --build-arg DATABASE_PASSWORD="my_password" \
             --build-arg COMMANDS="update;history" \
             --progress plain \
             --no-cache .
 ```

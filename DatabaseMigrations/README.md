# Releasing Database Changes

The release of Database changes is implemented using [Liquibase](https://www.liquibase.org/). 

To release a new database change add the script to the `.\SQL\changelog` directory. 


## 1 Use YAML
Consider using [YAML](https://docs.liquibase.com/concepts/basic/yaml-format.html) to describe database changes.

Liquibase will automatically translate the YAML into the the equivalent SQL statement for the target database.

This makes the YAML definitions database agnostic.


## 2 How to Implement Liquibase Changes

Liquibase ships with a large number of changes that can be applied to your database as well as the ability to write more through the [extension system](https://liquibase.jira.com/wiki/spaces/CONTRIB/overview).

To learn about how to implement Liquibase changes, see the [Change Types](https://docs.liquibase.com/change-types/home.html) documentation section.

Before implementing Liquibase changes, familiarize with [Liquibase best practices](https://docs.liquibase.com/concepts/bestpractices.html).


## 3 To test the Postgres database Locally
Please see [Local-PostGres.md](./docs/Local-PostGres.md)


## 4 Integrate Liquibase in the Azure release pipeline
Note: new Azure Pipelines needs to be created

 The [database-migration-azure-release-pipeline.yaml](./database-migration-azure-release-pipeline.yaml) template can be easily integrated into an Azure Devops pipeline by supplying the following parameters:

| Parameter                | Description |
|--------------------------|-------------|
| databaseConnectionString | The connectionstring to the database e.g. jdbc:postgresql://host.docker.internal:5432/YOUR-PROJECT-DB-NAME |
| databaseUsername         | The username used to connect to the database |
| databasePassword         | The password used to connect to the database |
| liquibaseCommands        | Semicolon delimited list of [Liquibase commands](https://docs.liquibase.com/commands/home.html) |
| changeLogFilesDirectory  | Absolute path to the directory containing the Liquibase changelogs to apply to the database |
| buildContext             | Absolute path to the directory where this repository is checked out |


### For example

 1) Create a Variable group with the secret to connect to the database 

 ```
    Variable Group Name: YOUR-PROJECT-NAME-Database-Secrets

    Secrets:
        - DATABASE-CONNECTION-STRING-DEV: jdbc:postgresql://dev.YOUR-PROJECT-NAME:5432/YOUR-PROJECT-NAMEDev"
        - DATABASE-USERNAME-DEV: UsernameForDEV
        - DATABASE-PASSWORD-DEV: PasswordDev
        
        - DATABASE-CONNECTION-STRING-PROD: jdbc:postgresql://prod.YOUR-PROJECT-NAME:5432/YOUR-PROJECT-NAMEProd"
        - DATABASE-USERNAME-PROD: UsernameForDEV
        - DATABASE-PASSWORD-PROD: PasswordDev
 ```

2) Create a pipeline from the following template

```
name: $(Date:yyyyMMdd)$(Rev:.r)-YOUR-PROJECT-NAME-Database-Migrations

parameters:  
  - name: environment
    displayName: Environment
    type: string
    default: test
    values:
    - dev
    - test
    - uat
    - beta
    - staging
    - prod
  - name: liquibaseCommands
    type: string
    default: history

variables:
  - group: YOUR-PROJECT-NAME-Database-Secrets
  
resources:
  repositories:
    - repository: DatabaseMigrations
      type: git
      name: Innersource/DatabaseMigrations

stages:
- stage: DatabaseMigration
  jobs:
    - job: ExecuteDatabaseMigration
      pool:
        name: Self-Hosted Linux
      steps:
      - checkout: self
      - checkout: DatabaseMigrations
      - template: database-migration-azure-release-pipeline.yaml@DatabaseMigrations
        parameters:
          buildContext: "$(System.DefaultWorkingDirectory)/DatabaseMigrations"
          changeLogFilesDirectory: "$(System.DefaultWorkingDirectory)/YOUR-PROJECT-NAME/SQL/changelog"
          databaseConnectionString: "$(DATABASE-CONNECTION-STRING-${{ parameters.environment }})"
          databaseUsername: "$(DATABASE-USERNAME-${{ parameters.environment }})"
          databasePassword: "$(DATABASE-PASSWORD-${{ parameters.environment }})"
          liquibaseCommands: "updateSQL;history" 
```

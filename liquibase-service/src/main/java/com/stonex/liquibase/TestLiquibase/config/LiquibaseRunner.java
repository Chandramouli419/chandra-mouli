package com.stonex.liquibase.TestLiquibase.config;

import liquibase.command.CommandScope;
import liquibase.command.core.UpdateCommandStep;
import liquibase.command.core.helpers.DbUrlConnectionCommandStep;
import liquibase.database.DatabaseFactory;
import liquibase.exception.CommandExecutionException;
import liquibase.exception.DatabaseException;
import liquibase.ext.mongodb.database.MongoLiquibaseDatabase;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.CommandLineRunner;
import org.springframework.stereotype.Component;

import java.util.List;

@Component
@Slf4j
public class LiquibaseRunner implements CommandLineRunner {

    public static final String DB_CHANGELOG_MASTER_XML = "/db/dbchangelog.xml";

    @Value("${spring.data.mongodb.uri}")
    private String mongoURL;

    @Value("${liquibase.contexts}")
    private String contexts;

    @Override
    public void run(String... args) throws Exception {
        log.info("Executing liquibase...");
        this.runLiquibase();

    }

    private void runLiquibase() throws DatabaseException, CommandExecutionException {
        System.setProperty("liquibase.mongodb.supportsValidator", "false");
        try (MongoLiquibaseDatabase database = (MongoLiquibaseDatabase)
                DatabaseFactory.getInstance().openDatabase(mongoURL, null, null, null, null)) {
            CommandScope updateCommand = new CommandScope(UpdateCommandStep.COMMAND_NAME);
            updateCommand.addArgumentValue(UpdateCommandStep.CHANGELOG_FILE_ARG, DB_CHANGELOG_MASTER_XML);
            updateCommand.addArgumentValue(DbUrlConnectionCommandStep.DATABASE_ARG, database);
            updateCommand.addArgumentValue(UpdateCommandStep.CONTEXTS_ARG, contexts);
            updateCommand.execute();
        }

    }
}

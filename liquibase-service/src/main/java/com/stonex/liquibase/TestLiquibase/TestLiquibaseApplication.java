package com.stonex.liquibase.TestLiquibase;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.ConfigurableApplicationContext;

@SpringBootApplication
public class TestLiquibaseApplication {

	public static void main(String[] args) {
		ConfigurableApplicationContext ctx =SpringApplication.run(TestLiquibaseApplication.class, args);
		int exitCode = SpringApplication.exit(ctx, () -> 0);
		System.exit(exitCode);
	}
}

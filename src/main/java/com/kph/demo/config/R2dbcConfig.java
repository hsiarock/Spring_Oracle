package com.kph.demo.config;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.data.r2dbc.config.AbstractR2dbcConfiguration;
import org.springframework.data.r2dbc.repository.config.EnableR2dbcRepositories;

import io.r2dbc.spi.ConnectionFactories;
import io.r2dbc.spi.ConnectionFactory;
import io.r2dbc.spi.ConnectionFactoryOptions;

@Configuration
@EnableR2dbcRepositories
public class R2dbcConfig extends AbstractR2dbcConfiguration { 
    
     @Value("${spring.r2dbc.url}")
     private String url;
 
     @Value("${spring.r2dbc.username}")
     private String username;
 
     @Value("${spring.r2dbc.password}")
     private String password;

     @Value("${demo.protocol}")
     private String dbprotocol;

     @Value("${demo.dbhost}")
     private String dbhost;

     @Value("${demo.dbport}")
     private int dbport;

     @Value("${demo.dbsvc}")
     private String dbsvc;

     @Value("${demo.dbname}")
     private String dbname;

    @Bean
    @Override
    public ConnectionFactory connectionFactory() {
        return ConnectionFactories.get(ConnectionFactoryOptions.builder()
            .option(ConnectionFactoryOptions.DRIVER, dbprotocol)
            //.option(ConnectionFactoryOptions.PROTOCOL, dbprotocol) // or your database protocol
            .option(ConnectionFactoryOptions.HOST, dbhost)
            .option(ConnectionFactoryOptions.PORT, 1521) // or your database port
            .option(ConnectionFactoryOptions.USER, username)
            .option(ConnectionFactoryOptions.PASSWORD, password)
            .option(ConnectionFactoryOptions.DATABASE, dbsvc) // or your database name
            .build());
    }
    /*
     * R2DBC defines a standard URL format that is an enhanced form of RFC 3986. The following example shows a valid R2DBC URL:
          r2dbc:a-driver:pipes://localhost:3306/my_database?locale=en_US
     */
}

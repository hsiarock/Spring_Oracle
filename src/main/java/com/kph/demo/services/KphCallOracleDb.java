package com.kph.demo.services;

import io.r2dbc.spi.Connection;
import io.r2dbc.spi.ConnectionFactories;
import io.r2dbc.spi.ConnectionFactory;
import io.r2dbc.spi.Result;
import io.r2dbc.spi.Statement;
import lombok.extern.slf4j.Slf4j;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.r2dbc.core.DatabaseClient;
import org.springframework.stereotype.Service;

import reactor.core.Disposable;
import reactor.core.publisher.Flux;
import reactor.core.publisher.Mono;

import java.util.ArrayList;
import java.util.List;
import java.util.NoSuchElementException;
import java.util.concurrent.Flow.Publisher;
import java.util.function.Function;
import java.util.stream.Collectors;

@Slf4j
@Service
public class KphCallOracleDb {

    private final ConnectionFactory connectionFactory;
    
    @Autowired
    public KphCallOracleDb(ConnectionFactory connectionFactory) {
        this.connectionFactory = connectionFactory;
    }

    public Mono<List<String>> querySQLGet1st(String sqlStmt) {
                
        log.info("Query with SQL: {} now", sqlStmt);

        return Flux.usingWhen(
                connectionFactory.create(),
                connection ->
                    Flux.from(connection.createStatement(sqlStmt).execute())
                        .flatMap(result -> result.map(row -> row.get(0, String.class)))
                        .doOnNext(System.out::println)
                        .doOnError(Throwable::printStackTrace),
                Connection::close)
                .collectList();

    }

    // public Flux<String> querySQLGetAll(String sqlStmt) {
                
    //     log.info("Query with SQL: {} now", sqlStmt);

    //     return Flux.usingWhen(
    //             connectionFactory.create(),
    //             connection ->
    //                 Mono.from(connection.createStatement(sqlStmt).execute()) // Mono<Result>
    //                     //.flatMap(result -> result.map(row -> row.get(0, String.class))) // row.getValues().toString()))
    //                      .flatMap(result -> result.map(row -> { 
    //                             RowMetadata metadata = row.getMetadata();
    //                             //List<String> columnNames = new ArrayList<>();
    //                             List<String> rowValues = new ArrayList<>();
    //                             for(int i = 0; i < metadata.getColumnCount(); i++) {
    //                                 String colName = metadata.getColumnName(i);
    //                                 //columnNames.add(colName);
    //                                 rowValues.add(row.get(colName, String.class));
    //                             }
    //                             return rowValues.collectList();
    //                         }))
    //                 ,
    //             Connection::close)
    //             //.collectList()
    //             ;
    //                     //.reduce((accumulated, current) -> accumulated + "," + current);
    // }

      //.subscribe(); //


    public Disposable callPlSqlProcedure(String city, String status) {
        String plSqlCall = "BEGIN LIST_HOUSE(:city, :status, :summary, :count); END;";
    
        log.info("CallProcedure : LIST_HOUSE with city: {}, status: {}", city, status);

        return Mono.from(connectionFactory.create())
            .flatMap(connection ->
                Mono.from(connection.createStatement(plSqlCall)
                    .bind("city", city)
                    .bind("status", status)
                    .bindNull("summary", String.class) // OUT parameter
                    .bindNull("count", Integer.class) // OUT parameter
                    .execute())
                .flatMap(result -> 
                        Flux.from(result.map((row, rowMetadata) -> row.get("summary", String.class)))
                                .next() // Assuming only one row is expected
                                .map(summary -> {
                                    log.info("Summary: {}", summary);
                                    return summary;
                                    //return count.toString(); // Convert count to string
                                })
                        )
                .doFinally(signalType -> connection.close())
            )
            .doOnSuccess(callResult -> log.info("Call Result: {}", callResult))
            .doOnError(error -> log.error("Call failed", error))
            .subscribe();
    }
    
    
    
                                // .concatWith(Mono.from(connection.close()))
                                //.reduce((accumulated, current) -> accumulated + "-" + current)
 
//                                    // Retrieve the OUT parameters
//                                    Integer count = statement.getOutParameter("count", Integer.class);
//                                    String summary = statement.getOutParameter("summary", String.class);
//                                    log.info("Count: {}", count);
//                                    log.info("Summary: {}", summary);
 
//                             .then(Mono.from(connection.close()));
//                 });
//     }

    // private Mono<String> processResult(Result result) {
    //     return result.flatMap(segment -> {
    //                 if (segment instanceof Result.RowSegment RowSegment) {
    //                     // Access data from each row
    //                     String name = RowSegment.get("name", String.class);
    //                     return Mono.just("User Name;" + name);
    //                 } else {
    //                     return Mono.empty();
    //                 }
    //             })
    //             .defaultEmpty("No House found");
    //             //.reduce((accumulated, current) -> accumulated + "\n" + current)  // combind row
    //             //.defaultEmpty("No House found");
    // }
    
        
}


package com.kph.demo.controller;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.dataformat.csv.CsvMapper;
import com.fasterxml.jackson.dataformat.csv.CsvSchema;
import com.kph.demo.model.House;
import com.kph.demo.repository.HouseR2dbcRepository;
import com.kph.demo.services.KphCallOracleDb;

import lombok.extern.slf4j.Slf4j;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.PageRequest;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import reactor.core.publisher.Flux;
import reactor.core.publisher.Mono;

import java.io.File;
import java.io.IOException;
import java.time.Duration;
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.util.List;
import java.util.UUID;

@RestController
@Slf4j
public class HouseController {

    @Autowired
    KphCallOracleDb kphCallOracleDb;

    private static final int DELAY_PER_ITEM_MS = 100;

    private final HouseR2dbcRepository houseR2dbcRepository;

    public HouseController(final HouseR2dbcRepository houseR2dbcRepository) {
        this.houseR2dbcRepository = houseR2dbcRepository;
    }

    @GetMapping("/README")
    public ResponseEntity<String> getReadme() {

        StringBuilder html = new StringBuilder();

        // Start HTML document
        html.append("<!DOCTYPE html>");
        html.append("<html>");
        html.append("<head>");
        html.append("<title>README First</title>");
        html.append("</head>");
        html.append("<body>");

        // Description
        html.append("<h1>Welcome to the DEMP projectd's README Page</h1>");
        html.append("<p>List of endpoints provided by this project.</p>");

        // Table
        html.append("<table border=\"1\">");
        html.append("<tr><th>Endpoint</th><th>Type</th><th>Description</th></tr>");

        // Sample data for the table
        List<String> link1 = List.of("/save", "POST", 
                "Save the JSON string from body");
        List<String> link2 = List.of("/house", "GET", 
                "Get the whole house data from DB");
        List<String> link3 = List.of("/house-page", "GET", 
                "Show by pages of House from DB");
        List<String> link4 = List.of("/exportCSV", "GET", 
                "List all hourse in CSV, also generate a 'houseLines.csv file in the current directory");
        List<String> link5 = List.of("/querySQL?sql=statement", "GET", 
                "Query DB using SQL statement");
        List<String> link6 = List.of("callProcedure?stmt=call statement", "GET", 
                "Call procedure: syntax Call proc-name(parm1, parm2...etc)");
                

        List<List<String>> svcList = List.of(link1, link2, link3, link4, link5, link6);

        // Populate the table
        for (int i = 0; i < svcList.size(); i++) {
            html.append("<tr>");
            List<String> row = svcList.get(i);
            for (String itm: row)
                html.append("<td>").append(itm).append("</td>");
            html.append("</tr>");
        }
        html.append("</table>");

        // End HTML document
        html.append("</body>");
        html.append("</html>");

        return new ResponseEntity<>(html.toString(), HttpStatus.OK);
    }

    @PostMapping(value = { "/save", "/"})
    @ResponseStatus(code = HttpStatus.CREATED)
    //@ResponseBody --> if use @RestController, included as default! So, no need it here
    public Mono<String> save(@RequestBody House house) {
        log.info("Saving a house object to db: " + house.getAddress());
        house.setCreDateTime(LocalDateTime.now(ZoneId.of("America/New_York")));
        UUID randomUUID = UUID.randomUUID();
        house.setId("Demo" + randomUUID.toString());
        return houseR2dbcRepository.save(house).map(h -> "saved: " + h.getAddress());
    }

    /*
     * e.g. http://localhost:8080/house
     */
    @GetMapping("/house")
    public Flux<House> getHouseFlux() {
        log.info("getHouseFlus(): ");
        return houseR2dbcRepository.findAll().delayElements(Duration.ofMillis(DELAY_PER_ITEM_MS));
    }

    /*
     * e.g. http://localhost:8080/house-paged?page=1&size=12
     */
    @GetMapping("/house-paged")
    public Flux<House> getHouseFlux(final @RequestParam(name = "page") int page,
                                    final @RequestParam(name = "size") int size) {
        log.info("getHouseFlux with paged:");
        return houseR2dbcRepository.findAllByIdNotNullOrderByIdAsc(PageRequest.of(page, size))
                .delayElements(Duration.ofMillis(DELAY_PER_ITEM_MS));
    }

    /*
     * export all data in CSV format, e.g. http://localhost:8080/exportCSV
     */
    @GetMapping("/exportCSV")
    public Mono<List<House>> getCSVHouseFlux() throws IOException {
        log.info("getCSVHouseFlux");

        CsvMapper csvMapper = new CsvMapper();
        csvMapper.findAndRegisterModules();

        CsvSchema csvSchema = csvMapper.schemaFor(House.class).withHeader();

        return houseR2dbcRepository.findAll()
            .collectList()
            .flatMap(retHouses -> {
                try {
                    String houseItem = csvMapper.writerFor(new TypeReference<List<House>>() {})
                                                .with(csvSchema)
                                                .writeValueAsString(retHouses);
                    csvMapper.writeValue(new File("houseLines.csv"), houseItem);
                    return Mono.just(retHouses); // Return the List<House>
                } catch (IOException e) {
                    return Mono.error(e); // Handle any exceptions
                }
            })
            .doFinally(signalType -> {
                // Perform any needed side-effect operations here
                // For example, logging the signal type
                log.info("Operation finished with signal: " + signalType);
            });

        /***************
        return csvMapper.writerFor(List.class).with(csvSchema).writeValueAsString(HouseArry);

        for (House house: retHouses) {
            //House[] HouseArry = retHouses.toArray(new House[0]);

                                            //.writeValue(new File("pathto/house_list.csv"), House);

        // Retrieve the list of houses as a Mono<List<House>>
         houseR2dbcRepository.findAll().map(house -> {
                //.doOnEach(house ->
            System.out.println("house: " + house);
            //House[] houseArray = house.toArray(new House[0]);
            try {

                //return houseItem;
            } catch (IOException e) {
                throw new RuntimeException(e);
            }
            return null;
        }).subscribe();
        *****************************/

    }

    @GetMapping("/querySQL1st")
    public Mono<List<String>> querySQL(@RequestParam(name = "sql") String sqlStmt) {

        log.info("Query using SQL: {}", sqlStmt);
        return kphCallOracleDb.querySQLGet1st(sqlStmt);
    }
    @GetMapping("/querySQL")
    public Flux<String> querySQLAll(@RequestParam(name = "sql") String sqlStmt) {

        log.info("Query using SQL with whole list: {}", sqlStmt);
        return kphCallOracleDb.querySQLGetAll(sqlStmt);
    }
    @GetMapping("/callProcedure")
    public String callProcedure(@RequestParam(name = "stmt") String callStm) {

        log.info("Call Procedure with parameters from caller: {}", callStm);
        kphCallOracleDb.callPlSqlProcedure("'Alhambra'", "'Active'");
        return "done";

    }
    

}
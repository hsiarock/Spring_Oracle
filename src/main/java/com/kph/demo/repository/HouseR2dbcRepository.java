package com.kph.demo.repository;

import com.kph.demo.model.House;

import org.springframework.data.domain.Pageable;
import org.springframework.data.r2dbc.repository.Query;
import org.springframework.data.r2dbc.repository.R2dbcRepository;
import org.springframework.data.repository.query.Param;

import reactor.core.publisher.Flux;
import reactor.core.publisher.Mono;

public interface HouseR2dbcRepository extends R2dbcRepository<House, String> { 
    //ReactiveSortingRepository<House, String> {

    Flux<House> findAllByIdNotNullOrderByIdAsc(final Pageable page);

    @Query("DELETE FROM house WHERE address = :addrVal")
    Mono<Void> deleteByAddress(@Param("addrVal") String someValue);

}

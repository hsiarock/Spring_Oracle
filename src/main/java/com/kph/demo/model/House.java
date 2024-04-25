package com.kph.demo.model;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import java.time.LocalDateTime;

import javax.persistence.Entity;
//import javax.persistence.GeneratedValue;
import javax.persistence.Id;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

//import org.hibernate.annotations.GenericGenerator;
import org.springframework.data.relational.core.mapping.Column;

@Builder
@Data
@AllArgsConstructor
@NoArgsConstructor
@JsonIgnoreProperties(ignoreUnknown = true)
@Entity
public final class House {

    @Id
    // @GeneratedValue(generator = "custom-id")
    // @GenericGenerator(name = "custom-id", strategy = "com.kph.demo.model.CustomIdGenerator")
    private String id;

    private int price;
    private String address;
    private String city;
    private String state;
    private String zip;
    private int bed;
    private int bath; // div by 10, e.g. 15=1.5, 50=5
    private int sqft;
    private int built;
    private int lots;
    @Column("ESTPRICE")
    private int estprice;
    @Column("PERSQRF")
    private int persqrf;
    private int hov;
    @Column("DAYONMARKET")
    private int dayOnMarket; // R2dbc auto-convert camelCase to snake_case, so force it to use camelCase
    @Column("CREDATETIME")
    private LocalDateTime creDateTime;
    @Column("OPENHOUSE")
    private LocalDateTime openHouse;
    @Column("DESCURL")
    private String descUrl;
    private String status; // Active, Sold, Pending, Inactive, Unknown
}

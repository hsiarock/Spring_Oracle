package com.kph.demo.controller;

// this class not been used

import org.springframework.boot.actuate.endpoint.annotation.Endpoint;
import org.springframework.boot.actuate.endpoint.annotation.ReadOperation;
import org.springframework.boot.actuate.endpoint.web.Link;
import org.springframework.boot.actuate.endpoint.web.annotation.WebEndpoint;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@Endpoint(id = "endpoints")
public class EndpointsEndpoint {

    private final List<Link> links;

    public EndpointsEndpoint(List<Link> links) {
        this.links = links;
    }

    @ReadOperation
    public ResponseEntity<List<Link>> getAllEndpoints() {
        return ResponseEntity.ok(links);
    }
}

// User Data Service: create a new RestController
package com.example.userdata.controller;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class TestController {

    @GetMapping("/api/user-data/test")
    public String testEndpoint() {
        return "User Data Service is up and running!";
    }
}

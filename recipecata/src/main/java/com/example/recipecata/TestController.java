package com.example.recipecata; // Assuming your package name is recipecatalog

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class TestController {

    @GetMapping("/api/recipes/test")
    public String testEndpoint() {
        return "Recipe Catalog Service is up and running!";
    }
}

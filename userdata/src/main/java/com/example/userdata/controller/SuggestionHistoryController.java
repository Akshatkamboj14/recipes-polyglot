package com.example.userdata.controller;

import com.example.userdata.entity.SuggestionHistory;
import com.example.userdata.service.SuggestionHistoryService;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/history")
public class SuggestionHistoryController {

    private final SuggestionHistoryService service;

    public SuggestionHistoryController(SuggestionHistoryService service) {
        this.service = service;
    }

    @PostMapping
    public SuggestionHistory saveHistory(@RequestBody SuggestionHistory history) {
        return service.saveHistory(history);
    }

    @GetMapping
    public List<SuggestionHistory> getAllHistory() {
        return service.getAllHistory();
    }

    @GetMapping("/{id}")
    public SuggestionHistory getHistoryById(@PathVariable Long id) {
        return service.getHistoryById(id);
    }

    @DeleteMapping("/{id}")
    public void deleteHistory(@PathVariable Long id) {
        service.deleteHistory(id);
    }
}


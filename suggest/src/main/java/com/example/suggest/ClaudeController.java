package com.example.suggest;

import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/claude")
public class ClaudeController {

    private final ClaudeService claudeService;

    public ClaudeController(ClaudeService claudeService) {
        this.claudeService = claudeService;
    }

    @GetMapping("/ask")
    public String ask(@RequestParam String q) {
        return claudeService.askClaude(q);
    }
}


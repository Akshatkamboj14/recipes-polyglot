package com.example.suggest; // Update to your package name

import org.springframework.ai.bedrock.titan.BedrockTitanChatModel;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class BedrockTestController {

    private final BedrockTitanChatModel chatModel;

    @Autowired
    public BedrockTestController(BedrockTitanChatModel chatModel) {
        this.chatModel = chatModel;
    }

    @GetMapping("/api/suggest/test")
    public String testEndpoint() {
        return this.chatModel.call("Suggest a simple Indian recipe.");
    }
}

package com.example.userdata.service;

import com.example.userdata.entity.SuggestionHistory;
import com.example.userdata.repository.SuggestionHistoryRepository;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class SuggestionHistoryService {

    private final SuggestionHistoryRepository repository;

    public SuggestionHistoryService(SuggestionHistoryRepository repository) {
        this.repository = repository;
    }

    public SuggestionHistory saveHistory(SuggestionHistory history) {
        return repository.save(history);
    }

    public List<SuggestionHistory> getAllHistory() {
        return repository.findAll();
    }

    public SuggestionHistory getHistoryById(Long id) {
        return repository.findById(id).orElse(null);
    }

    public void deleteHistory(Long id) {
        repository.deleteById(id);
    }
}


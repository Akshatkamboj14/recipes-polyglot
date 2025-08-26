package com.example.userdata.repository;

import com.example.userdata.entity.SuggestionHistory;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface SuggestionHistoryRepository extends JpaRepository<SuggestionHistory, Long> {
}


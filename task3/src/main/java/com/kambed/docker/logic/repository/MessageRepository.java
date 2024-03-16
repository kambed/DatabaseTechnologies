package com.kambed.docker.logic.repository;

import com.kambed.docker.logic.model.domain.Message;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

@Repository
public interface MessageRepository extends JpaRepository<Message, Long> {

    @Query(value = "SELECT * FROM message ORDER BY id", countQuery = "SELECT count(*) FROM message", nativeQuery = true)
    Page<Message> findAllPaged(Pageable pageable);
}
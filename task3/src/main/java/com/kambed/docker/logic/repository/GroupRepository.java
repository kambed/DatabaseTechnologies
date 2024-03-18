package com.kambed.docker.logic.repository;

import com.kambed.docker.logic.model.domain.Group;
import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.data.mongodb.repository.Query;

public interface GroupRepository extends MongoRepository<Group, String> {

    @Query("{'name': ?0}")
    Group findByName(String name);
}

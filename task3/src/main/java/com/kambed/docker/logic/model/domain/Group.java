package com.kambed.docker.logic.model.domain;

import lombok.*;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
@Document(collection = "groups")
public class Group {

    @Id
    private String id;
    private String name;
    private String description;
    private Boolean isPrivate;
}

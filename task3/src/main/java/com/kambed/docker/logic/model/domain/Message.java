package com.kambed.docker.logic.model.domain;

import lombok.*;
import org.springframework.data.mongodb.core.mapping.DBRef;
import org.springframework.data.mongodb.core.mapping.Document;

import java.time.LocalDateTime;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
@Document(collection = "messages")
public class Message {

    private String id;
    @DBRef
    private User sender;
    @DBRef
    private User receiver;
    private String content;
    private LocalDateTime timestamp;
}

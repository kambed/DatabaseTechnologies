package com.kambed.docker.logic.mapper;

import com.kambed.docker.logic.model.domain.Message;
import com.kambed.docker.logic.model.dto.MessageDto;
import org.springframework.stereotype.Component;

import java.util.function.Function;

@Component
public class MessageDtoMapper implements Function<Message, MessageDto> {

    @Override
    public MessageDto apply(Message message) {
        return new MessageDto(
                message.getId(),
                message.getUsername(),
                message.getMessage()
        );
    }
}

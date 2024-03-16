package com.kambed.docker.logic.service;

import com.kambed.docker.logic.exception.MessageNotFoundException;
import com.kambed.docker.logic.model.domain.Message;
import com.kambed.docker.logic.repository.MessageRepository;
import com.kambed.docker.logic.mapper.MessageDtoMapper;
import com.kambed.docker.logic.model.command.MessageCreateCommand;
import com.kambed.docker.logic.model.command.MessageUpdateCommand;
import com.kambed.docker.logic.model.dto.MessageDto;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@RequiredArgsConstructor
public class MessageService {

    private final MessageRepository messageRepository;
    private final MessageDtoMapper messageDtoMapper;
    private final String MESSAGE_NOT_FOUND = "Message with id: %s not found!";

    @Transactional(readOnly = true)
    public List<MessageDto> getAllMessages() {
        return messageRepository
                .findAll()
                .stream()
                .map(messageDtoMapper)
                .toList();
    }

    @Transactional(readOnly = true)
    public Page<MessageDto> getMessages(Pageable pageable) {
        return messageRepository.findAllPaged(pageable).map(messageDtoMapper);
    }

    @Transactional(readOnly = true)
    public MessageDto getMessage(Long id) {
        return messageRepository
                .findById(id)
                .map(messageDtoMapper)
                .orElseThrow(() -> new MessageNotFoundException(
                        MESSAGE_NOT_FOUND.formatted(id)
                ));
    }

    @Transactional
    public MessageDto createMessage(MessageCreateCommand messageCreateCommand) {
        Message message = new Message(
                messageCreateCommand.getUsername(),
                messageCreateCommand.getMessage()
        );
        messageRepository.saveAndFlush(message);
        return messageDtoMapper.apply(message);
    }

    @Transactional
    public MessageDto updateMessage(MessageUpdateCommand messageUpdateCommand) {
        Message originalMessage = messageRepository
                .findById(messageUpdateCommand.getId())
                .orElseThrow(() -> new MessageNotFoundException(
                        MESSAGE_NOT_FOUND.formatted(messageUpdateCommand.getId())
                ));
        Message message = new Message();
        message.setId(originalMessage.getId());
        message.setUsername(messageUpdateCommand.getUsername() == null ?
                originalMessage.getUsername() : messageUpdateCommand.getUsername());
        message.setMessage(messageUpdateCommand.getMessage() == null ?
                originalMessage.getMessage() : messageUpdateCommand.getMessage());
        messageRepository.saveAndFlush(message);
        return messageDtoMapper.apply(message);
    }

    @Transactional
    public void deleteMessage(Long id) {
        messageRepository.deleteById(id);
    }
}

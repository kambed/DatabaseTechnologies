package com.kambed.docker.logic.controller;

import com.kambed.docker.logic.model.command.MessageUpdateCommand;
import com.kambed.docker.logic.service.MessageService;
import com.kambed.docker.logic.model.command.MessageCreateCommand;
import com.kambed.docker.logic.model.dto.MessageDto;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.web.PageableDefault;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@CrossOrigin
@RequiredArgsConstructor
@RequestMapping("/message")
public class MessageController {

    private final MessageService messageService;

    @GetMapping("/all")
    public ResponseEntity<List<MessageDto>> getAllMessages() {
        return ResponseEntity.ok(messageService.getAllMessages());
    }

    @GetMapping
    public ResponseEntity<Page<MessageDto>> getMessages(@PageableDefault Pageable pageable) {
        return ResponseEntity.ok(messageService.getMessages(pageable));
    }

    @GetMapping("/{id}")
    public ResponseEntity<MessageDto> getMessage(@PathVariable Long id) {
        return ResponseEntity.ok(messageService.getMessage(id));
    }

    @PostMapping
    public ResponseEntity<MessageDto> createMessage(@RequestBody @Valid MessageCreateCommand messageCreateCommand) {
        MessageDto messageDto = messageService.createMessage(messageCreateCommand);
        return ResponseEntity.status(HttpStatus.CREATED).body(messageDto);
    }

    @PutMapping
    public ResponseEntity<MessageDto> editMessage(@RequestBody @Valid MessageUpdateCommand messageUpdateCommand) {
        MessageDto messageDto = messageService.updateMessage(messageUpdateCommand);
        return ResponseEntity.ok(messageDto);
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<MessageDto> deleteMessage(@PathVariable Long id) {
        messageService.deleteMessage(id);
        return ResponseEntity.noContent().build();
    }
}

package com.kambed.docker.logic.controller;

import com.kambed.docker.logic.model.command.UserCreateCommand;
import com.kambed.docker.logic.model.command.UserUpdateCommand;
import com.kambed.docker.logic.model.dto.UserDto;
import com.kambed.docker.logic.service.UserService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@CrossOrigin
@RequiredArgsConstructor
@RequestMapping("/user")
public class UserController {

    private final UserService userService;

    @GetMapping("/all")
    public ResponseEntity<List<UserDto>> getAllUsers() {
        return ResponseEntity.ok(userService.getAllUsers());
    }

    @GetMapping("/{username}")
    public ResponseEntity<UserDto> getUserByUsername(@PathVariable String username) {
        return ResponseEntity.ok(userService.getUserByUsername(username));
    }

    @PostMapping
    public ResponseEntity<UserDto> createUser(@RequestBody UserCreateCommand userCreateCommand) {
        return ResponseEntity.ok(userService.createUser(userCreateCommand));
    }

    @PutMapping
    public ResponseEntity<UserDto> updateUser(@RequestBody UserUpdateCommand userUpdateCommand) {
        return ResponseEntity.ok(userService.updateUser(userUpdateCommand));
    }
}

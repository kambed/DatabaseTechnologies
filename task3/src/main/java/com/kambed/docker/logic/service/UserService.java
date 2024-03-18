package com.kambed.docker.logic.service;

import com.kambed.docker.logic.exception.UserNotFoundException;
import com.kambed.docker.logic.mapper.UserDtoMapper;
import com.kambed.docker.logic.model.command.UserCreateCommand;
import com.kambed.docker.logic.model.command.UserUpdateCommand;
import com.kambed.docker.logic.model.domain.User;
import com.kambed.docker.logic.model.dto.UserDto;
import com.kambed.docker.logic.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@RequiredArgsConstructor
public class UserService {

    private final UserRepository userRepository;
    private final UserDtoMapper userDtoMapper;
    private static final String USER_NOT_FOUND = "User with id: %s not found!";
    private static final String USER_BY_USERNAME_NOT_FOUND = "User with username: %s not found!";

    @Transactional(readOnly = true)
    public List<UserDto> getAllUsers() {
        return userRepository.findAll().stream().map(userDtoMapper).toList();
    }

    @Transactional(readOnly = true)
    public UserDto getUserByUsername(String username) {
        User user = userRepository.findByUsername(username);
        if (user == null) {
            throw new UserNotFoundException(String.format(USER_BY_USERNAME_NOT_FOUND, username));
        }
        return userDtoMapper.apply(user);
    }

    @Transactional
    public UserDto createUser(UserCreateCommand userCreateCommand) {
        if (userRepository.findByUsername(userCreateCommand.getUsername()) != null) {
            throw new IllegalArgumentException("Username already exists");
        }
        User user = User.builder()
                .username(userCreateCommand.getUsername())
                .firstName(userCreateCommand.getFirstName())
                .lastName(userCreateCommand.getLastName())
                .email(userCreateCommand.getEmail())
                .build();
        return userDtoMapper.apply(userRepository.save(user));
    }

    @Transactional
    public UserDto updateUser(UserUpdateCommand userUpdateCommand) {
        User user = userRepository.findById(userUpdateCommand.getId())
                .orElseThrow(() -> new UserNotFoundException(String.format(USER_NOT_FOUND, userUpdateCommand.getId())));
        user.setUsername(userUpdateCommand.getUsername());
        user.setFirstName(userUpdateCommand.getFirstName());
        user.setLastName(userUpdateCommand.getLastName());
        user.setEmail(userUpdateCommand.getEmail());
        return userDtoMapper.apply(userRepository.save(user));
    }
}

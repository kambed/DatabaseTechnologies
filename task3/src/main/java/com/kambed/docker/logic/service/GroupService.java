package com.kambed.docker.logic.service;

import com.kambed.docker.logic.exception.GroupNotFoundException;
import com.kambed.docker.logic.mapper.GroupDtoMapper;
import com.kambed.docker.logic.model.command.GroupCreateCommand;
import com.kambed.docker.logic.model.domain.Group;
import com.kambed.docker.logic.model.dto.GroupDto;
import com.kambed.docker.logic.repository.GroupRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@RequiredArgsConstructor
public class GroupService {

    private final GroupRepository groupRepository;
    private final GroupDtoMapper groupDtoMapper;
    private static final String GROUP_NOT_FOUND = "Group with name: %s not found!";

    @Transactional(readOnly = true)
    public List<GroupDto> getAllGroups() {
        return groupRepository.findAll().stream().map(groupDtoMapper).toList();
    }

    @Transactional(readOnly = true)
    public GroupDto getGroupByName(String username) {
        Group group = groupRepository.findByName(username);
        if (group == null) {
            throw new GroupNotFoundException(String.format(GROUP_NOT_FOUND, username));
        }
        return groupDtoMapper.apply(groupRepository.findByName(username));
    }

    @Transactional
    public GroupDto createGroup(GroupCreateCommand groupCreateCommand) {
        if (groupRepository.findByName(groupCreateCommand.getName()) != null) {
            throw new IllegalArgumentException("Group with this name already exists");
        }
        Group group = Group.builder()
                .name(groupCreateCommand.getName())
                .description(groupCreateCommand.getDescription())
                .isPrivate(groupCreateCommand.getIsPrivate())
                .build();
        return groupDtoMapper.apply(groupRepository.save(group));
    }
}

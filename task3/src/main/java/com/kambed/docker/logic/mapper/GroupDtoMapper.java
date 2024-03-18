package com.kambed.docker.logic.mapper;

import com.kambed.docker.logic.model.domain.Group;
import com.kambed.docker.logic.model.dto.GroupDto;
import org.springframework.stereotype.Component;

import java.util.function.Function;

@Component
public class GroupDtoMapper implements Function<Group, GroupDto> {

    @Override
    public GroupDto apply(Group group) {
        return new GroupDto(
                group.getId(),
                group.getName(),
                group.getDescription(),
                group.getIsPrivate()
        );
    }
}

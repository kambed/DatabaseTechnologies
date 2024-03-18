package com.kambed.docker.logic.controller;

import com.kambed.docker.logic.model.command.GroupCreateCommand;
import com.kambed.docker.logic.model.dto.GroupDto;
import com.kambed.docker.logic.service.GroupService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@CrossOrigin
@RequiredArgsConstructor
@RequestMapping("/group")
public class GroupController {

    private final GroupService groupService;

    @GetMapping("/all")
    public ResponseEntity<List<GroupDto>> getAllGroups() {
        return ResponseEntity.ok(groupService.getAllGroups());
    }

    @GetMapping("/{name}")
    public ResponseEntity<GroupDto> getGroupByName(@PathVariable String name) {
        return ResponseEntity.ok(groupService.getGroupByName(name));
    }

    @PostMapping
    public ResponseEntity<GroupDto> createGroup(@RequestBody GroupCreateCommand groupCreateCommand) {
        return ResponseEntity.ok(groupService.createGroup(groupCreateCommand));
    }
}

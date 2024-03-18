package com.kambed.docker.logic.model.command;

import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.Size;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class GroupCreateCommand {

    @Schema(description = "Group name", example = "BEER", requiredMode = Schema.RequiredMode.REQUIRED)
    @Size(max = 256, message = "The group name does not meet the text length requirements")
    private String name;
    @Schema(description = "Description", example = "Beer lovers", requiredMode = Schema.RequiredMode.NOT_REQUIRED)
    @Size(max = 1024, message = "The description does not meet the text length requirements")
    private String description;
    @Schema(description = "Is private", example = "false", requiredMode = Schema.RequiredMode.NOT_REQUIRED)
    private Boolean isPrivate;
}

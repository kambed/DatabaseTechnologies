package com.kambed.docker.logic.model.dto;

import io.swagger.v3.oas.annotations.media.Schema;

public record GroupDto(
        @Schema(description = "Group id", example = "65f74892d1ab0e2e83dbcc7c", requiredMode = Schema.RequiredMode.REQUIRED)
        String id,
        @Schema(description = "Name", example = "BEER", requiredMode = Schema.RequiredMode.REQUIRED)
        String name,
        @Schema(description = "Description", example = "Beer lovers", requiredMode = Schema.RequiredMode.NOT_REQUIRED)
        String description,
        @Schema(description = "Is private", example = "false", requiredMode = Schema.RequiredMode.NOT_REQUIRED)
        Boolean isPrivate
) {
}

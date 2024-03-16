package com.kambed.docker.logic.model.dto;

import io.swagger.v3.oas.annotations.media.Schema;

public record MessageDto(
        @Schema(description = "Message id", example = "1", requiredMode = Schema.RequiredMode.REQUIRED)
        Long id,
        @Schema(description = "Message sender", example = "Pablo", requiredMode = Schema.RequiredMode.NOT_REQUIRED)
        String username,
        @Schema(description = "Message content", example = "Hello world!", requiredMode = Schema.RequiredMode.REQUIRED)
        String message
) {
}

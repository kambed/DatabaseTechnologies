package com.kambed.docker.logic.model.dto;

import io.swagger.v3.oas.annotations.media.Schema;

public record UserDto(
        @Schema(description = "User id", example = "65f74892d1ab0e2e83dbcc7c", requiredMode = Schema.RequiredMode.REQUIRED)
        String id,
        @Schema(description = "Username", example = "pablos", requiredMode = Schema.RequiredMode.REQUIRED)
        String username,
        @Schema(description = "First name", example = "Pablo", requiredMode = Schema.RequiredMode.NOT_REQUIRED)
        String firstName,
        @Schema(description = "Last name", example = "Escobar", requiredMode = Schema.RequiredMode.NOT_REQUIRED)
        String lastName,
        @Schema(description = "Email", example = "pablo.escobar@gmail.com", requiredMode = Schema.RequiredMode.NOT_REQUIRED)
        String email
) {
}

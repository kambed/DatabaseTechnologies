package com.kambed.docker.logic.model.command;

import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import lombok.*;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class MessageUpdateCommand {

    @Schema(description = "Message id", example = "1", requiredMode = Schema.RequiredMode.REQUIRED)
    @NotNull(message = "The message id cannot be null")
    private Long id;

    @Schema(description = "Message sender", example = "Pablo Escobar", requiredMode = Schema.RequiredMode.NOT_REQUIRED)
    @Size(max = 256, message = "The username does not meet the text length requirements")
    private String username;

    @Schema(description = "Message content", example = "Hello world! :O", requiredMode = Schema.RequiredMode.REQUIRED)
    @Size(max = 1024, message = "The message content does not meet the text length requirements")
    private String message;
}

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
public class UserCreateCommand {

    @Schema(description = "Username", example = "pablos", requiredMode = Schema.RequiredMode.REQUIRED)
    @Size(max = 256, message = "The username does not meet the text length requirements")
    private String username;
    @Schema(description = "First name", example = "Pablo", requiredMode = Schema.RequiredMode.NOT_REQUIRED)
    @Size(max = 256, message = "The first name does not meet the text length requirements")
    private String firstName;
    @Schema(description = "Last name", example = "Escobar", requiredMode = Schema.RequiredMode.NOT_REQUIRED)
    @Size(max = 256, message = "The last name does not meet the text length requirements")
    private String lastName;
    @Schema(description = "Email", example = "pablo.escobar@gmail.com", requiredMode = Schema.RequiredMode.NOT_REQUIRED)
    @Size(max = 1024, message = "The email does not meet the text length requirements")
    private String email;
}

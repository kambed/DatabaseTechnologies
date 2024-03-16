package com.kambed.docker.handling.response;

import java.util.Map;

public record ErrorResponse(
        String message,
        int statusCode,
        Map<String, String> errors
) {

}
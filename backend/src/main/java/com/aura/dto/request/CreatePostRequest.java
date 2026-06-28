package com.aura.dto.request;

import jakarta.validation.constraints.NotBlank;
import lombok.Data;

@Data
public class CreatePostRequest {
    private String caption;
    private String mediaUrl;
    private String mediaType;
    private String location;
}

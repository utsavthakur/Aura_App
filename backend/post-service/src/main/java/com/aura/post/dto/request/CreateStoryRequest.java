package com.aura.post.dto.request;

import jakarta.validation.constraints.NotBlank;
import lombok.Data;

@Data
public class CreateStoryRequest {
    @NotBlank
    private String mediaUrl;
    private String mediaType;
}

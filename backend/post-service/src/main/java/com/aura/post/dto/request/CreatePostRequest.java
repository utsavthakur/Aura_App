package com.aura.post.dto.request;

import lombok.Data;

@Data
public class CreatePostRequest {
    private String caption;
    private String mediaUrl;
    private String mediaType;
    private String location;
}

package com.aura.dto.response;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import java.time.Instant;
import java.util.UUID;

@Data @AllArgsConstructor @Builder
public class PostResponse {
    private UUID id;
    private UserSummary user;
    private String caption;
    private String content;
    private String mediaUrl;
    private String mediaType;
    private String location;
    private int likeCount;
    private int commentCount;
    private Instant createdAt;
    private boolean likedByMe;
}

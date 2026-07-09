package com.aura.post.dto.response;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import java.time.Instant;
import java.util.UUID;

@Data
@AllArgsConstructor
@Builder
public class StoryResponse {
    private UUID id;
    private UUID userId;
    private String username;
    private String userAvatarUrl;
    private String mediaUrl;
    private String mediaType;
    private Instant expiresAt;
    private Instant createdAt;
}

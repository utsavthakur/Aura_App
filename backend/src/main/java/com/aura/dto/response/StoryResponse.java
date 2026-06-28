package com.aura.dto.response;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import java.time.Instant;
import java.util.UUID;

@Data @AllArgsConstructor @Builder
public class StoryResponse {
    private UUID id;
    private UserSummary user;
    private String mediaUrl;
    private String mediaType;
    private Instant expiresAt;
    private Instant createdAt;
}

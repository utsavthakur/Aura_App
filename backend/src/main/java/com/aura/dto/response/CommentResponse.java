package com.aura.dto.response;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import java.time.Instant;
import java.util.UUID;

@Data @AllArgsConstructor @Builder
public class CommentResponse {
    private UUID id;
    private UserSummary user;
    private UUID postId;
    private String content;
    private Instant createdAt;
}

package com.aura.dto.response;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import java.time.Instant;
import java.util.UUID;

@Data @AllArgsConstructor @Builder
public class MessageResponse {
    private UUID id;
    private UserSummary sender;
    private UserSummary receiver;
    private String content;
    private boolean isRead;
    private Instant createdAt;
}

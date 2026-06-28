package com.aura.dto.response;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import java.time.Instant;
import java.util.UUID;

@Data @AllArgsConstructor @Builder
public class NotificationResponse {
    private UUID id;
    private String type;
    private UserSummary actor;
    private UUID referenceId;
    private String message;
    private boolean isRead;
    private Instant createdAt;
}

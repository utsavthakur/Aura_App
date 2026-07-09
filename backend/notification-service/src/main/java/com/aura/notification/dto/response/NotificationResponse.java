package com.aura.notification.dto.response;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import java.time.Instant;
import java.util.UUID;

@Data
@AllArgsConstructor
@Builder
public class NotificationResponse {
    private UUID id;
    private String type;
    private UUID actorId;
    private UUID referenceId;
    private String message;
    private boolean isRead;
    private Instant createdAt;
}

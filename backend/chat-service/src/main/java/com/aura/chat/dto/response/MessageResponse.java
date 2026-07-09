package com.aura.chat.dto.response;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import java.time.Instant;
import java.util.UUID;

@Data
@AllArgsConstructor
@Builder
public class MessageResponse {
    private UUID id;
    private UUID senderId;
    private UUID receiverId;
    private String content;
    private boolean isRead;
    private Instant createdAt;
}

package com.aura.dto.request;

import jakarta.validation.constraints.NotBlank;
import lombok.Data;
import java.util.UUID;

@Data
public class SendMessageRequest {
    @NotBlank
    private UUID receiverId;

    @NotBlank
    private String content;
}

package com.aura.dto.response;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import java.util.UUID;

@Data @AllArgsConstructor @Builder
public class AuthResponse {
    private String token;
    private UUID userId;
    private String username;
    private String email;
    private String avatarUrl;
}

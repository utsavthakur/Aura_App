package com.aura.dto.response;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import java.util.UUID;

@Data @AllArgsConstructor @Builder
public class UserSummary {
    private UUID id;
    private String username;
    private String avatarUrl;
}

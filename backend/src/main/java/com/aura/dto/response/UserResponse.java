package com.aura.dto.response;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import java.time.Instant;
import java.util.UUID;

@Data @AllArgsConstructor @Builder
public class UserResponse {
    private UUID id;
    private String username;
    private String email;
    private String bio;
    private String avatarUrl;
    private Instant createdAt;
    private long postCount;
    private long followerCount;
    private long followingCount;
}

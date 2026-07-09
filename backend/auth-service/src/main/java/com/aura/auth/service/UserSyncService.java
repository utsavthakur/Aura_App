package com.aura.auth.service;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

import java.util.Map;
import java.util.UUID;

@Service
@RequiredArgsConstructor
@Slf4j
public class UserSyncService {

    private final RestTemplate restTemplate;

    @Value("${app.user-service.url:http://localhost:8082}")
    private String userServiceUrl;

    public void syncNewUser(UUID userId, String username, String email) {
        try {
            restTemplate.postForEntity(
                userServiceUrl + "/api/users/internal/create",
                Map.of("id", userId, "username", username, "email", email),
                Void.class
            );
            log.info("Synced user {} to user-service", userId);
        } catch (Exception e) {
            log.error("Failed to sync user {} to user-service: {}", userId, e.getMessage());
        }
    }
}

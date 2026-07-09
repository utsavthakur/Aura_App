package com.aura.auth.controller;

import com.aura.auth.dto.request.LoginRequest;
import com.aura.auth.dto.request.SignUpRequest;
import com.aura.auth.dto.response.AuthResponse;
import com.aura.auth.service.AuthService;
import com.aura.auth.service.UserSyncService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/auth")
@RequiredArgsConstructor
public class AuthController {

    private final AuthService authService;
    private final UserSyncService userSyncService;

    @PostMapping("/register")
    public ResponseEntity<AuthResponse> register(@Valid @RequestBody SignUpRequest request) {
        AuthResponse response = authService.register(request);
        userSyncService.syncNewUser(response.getUserId(), response.getUsername(), response.getEmail());
        return ResponseEntity.ok(response);
    }

    @PostMapping("/login")
    public ResponseEntity<AuthResponse> login(@Valid @RequestBody LoginRequest request) {
        return ResponseEntity.ok(authService.login(request));
    }
}

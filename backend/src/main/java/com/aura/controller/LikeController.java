package com.aura.controller;

import com.aura.dto.response.UserSummary;
import com.aura.service.LikeService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;
import java.util.UUID;

@RestController
@RequestMapping("/api/posts/{id}/likes")
@RequiredArgsConstructor
public class LikeController {

    private final LikeService likeService;

    @PostMapping
    public ResponseEntity<Map<String, Object>> toggleLike(
            @PathVariable UUID id,
            @AuthenticationPrincipal UUID currentUserId) {
        return ResponseEntity.ok(likeService.toggleLike(id, currentUserId));
    }

    @GetMapping
    public ResponseEntity<List<UserSummary>> getLikes(@PathVariable UUID id) {
        return ResponseEntity.ok(likeService.getPostLikes(id));
    }
}

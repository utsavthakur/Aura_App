package com.aura.post.controller;

import com.aura.post.dto.response.LikeResponse;
import com.aura.post.service.LikeService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;

import java.util.UUID;

@RestController
@RequestMapping("/api/posts/{postId}/likes")
@RequiredArgsConstructor
public class LikeController {

    private final LikeService likeService;

    @PostMapping
    public ResponseEntity<LikeResponse> toggleLike(
            @PathVariable UUID postId,
            @AuthenticationPrincipal UUID userId) {
        return ResponseEntity.ok(likeService.toggleLike(postId, userId));
    }
}

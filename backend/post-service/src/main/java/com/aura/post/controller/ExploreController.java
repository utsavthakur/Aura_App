package com.aura.post.controller;

import com.aura.common.dto.response.PagedResponse;
import com.aura.post.dto.response.PostResponse;
import com.aura.post.service.ExploreService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;

import java.util.UUID;

@RestController
@RequestMapping("/api/explore")
@RequiredArgsConstructor
public class ExploreController {

    private final ExploreService exploreService;

    @GetMapping
    public ResponseEntity<PagedResponse<PostResponse>> getExploreFeed(
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "10") int size,
            @AuthenticationPrincipal UUID currentUserId) {
        return ResponseEntity.ok(exploreService.getExploreFeed(page, size, currentUserId));
    }

    @GetMapping("/search")
    public ResponseEntity<PagedResponse<PostResponse>> search(
            @RequestParam String q,
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "10") int size,
            @AuthenticationPrincipal UUID currentUserId) {
        return ResponseEntity.ok(exploreService.search(q, page, size, currentUserId));
    }
}

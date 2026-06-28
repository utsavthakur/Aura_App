package com.aura.controller;

import com.aura.dto.response.PagedResponse;
import com.aura.dto.response.PostResponse;
import com.aura.service.ExploreService;
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
    public ResponseEntity<PagedResponse<PostResponse>> getExplore(
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "20") int size,
            @AuthenticationPrincipal UUID currentUserId) {
        return ResponseEntity.ok(exploreService.getExploreFeed(page, size, currentUserId));
    }

    @GetMapping("/search")
    public ResponseEntity<PagedResponse<PostResponse>> search(
            @RequestParam String q,
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "20") int size,
            @AuthenticationPrincipal UUID currentUserId) {
        return ResponseEntity.ok(exploreService.search(q, page, size, currentUserId));
    }
}

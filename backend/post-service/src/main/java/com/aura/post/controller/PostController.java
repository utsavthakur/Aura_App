package com.aura.post.controller;

import com.aura.common.dto.response.PagedResponse;
import com.aura.post.dto.request.CreatePostRequest;
import com.aura.post.dto.response.PostResponse;
import com.aura.post.service.PostService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;

import java.util.UUID;

@RestController
@RequestMapping("/api/posts")
@RequiredArgsConstructor
public class PostController {

    private final PostService postService;

    @GetMapping
    public ResponseEntity<PagedResponse<PostResponse>> getFeed(
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "10") int size,
            @AuthenticationPrincipal UUID currentUserId) {
        return ResponseEntity.ok(postService.getFeed(page, size, currentUserId));
    }

    @PostMapping
    public ResponseEntity<PostResponse> createPost(
            @Valid @RequestBody CreatePostRequest request,
            @AuthenticationPrincipal UUID userId) {
        return ResponseEntity.ok(postService.createPost(request, userId));
    }

    @GetMapping("/{id}")
    public ResponseEntity<PostResponse> getPost(
            @PathVariable UUID id,
            @AuthenticationPrincipal UUID currentUserId) {
        return ResponseEntity.ok(postService.getPost(id, currentUserId));
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deletePost(
            @PathVariable UUID id,
            @AuthenticationPrincipal UUID userId) {
        postService.deletePost(id, userId);
        return ResponseEntity.noContent().build();
    }

    @GetMapping("/user/{userId}")
    public ResponseEntity<PagedResponse<PostResponse>> getUserPosts(
            @PathVariable UUID userId,
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "10") int size,
            @AuthenticationPrincipal UUID currentUserId) {
        return ResponseEntity.ok(postService.getUserPosts(userId, page, size, currentUserId));
    }
}

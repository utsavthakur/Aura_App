package com.aura.controller;

import com.aura.dto.request.CreateCommentRequest;
import com.aura.dto.response.CommentResponse;
import com.aura.service.CommentService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.UUID;

@RestController
@RequestMapping("/api/posts/{id}/comments")
@RequiredArgsConstructor
public class CommentController {

    private final CommentService commentService;

    @GetMapping
    public ResponseEntity<List<CommentResponse>> getComments(@PathVariable UUID id) {
        return ResponseEntity.ok(commentService.getPostComments(id));
    }

    @PostMapping
    public ResponseEntity<CommentResponse> createComment(
            @PathVariable UUID id,
            @Valid @RequestBody CreateCommentRequest request,
            @AuthenticationPrincipal UUID currentUserId) {
        return ResponseEntity.ok(commentService.createComment(id, request, currentUserId));
    }

    @DeleteMapping("/{commentId}")
    public ResponseEntity<Void> deleteComment(
            @PathVariable UUID commentId,
            @AuthenticationPrincipal UUID currentUserId) {
        commentService.deleteComment(commentId, currentUserId);
        return ResponseEntity.noContent().build();
    }
}

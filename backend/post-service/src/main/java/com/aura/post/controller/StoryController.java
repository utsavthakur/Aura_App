package com.aura.post.controller;

import com.aura.post.dto.request.CreateStoryRequest;
import com.aura.post.dto.response.StoryResponse;
import com.aura.post.service.StoryService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.UUID;

@RestController
@RequestMapping("/api/stories")
@RequiredArgsConstructor
public class StoryController {

    private final StoryService storyService;

    @GetMapping
    public ResponseEntity<List<StoryResponse>> getActiveStories() {
        return ResponseEntity.ok(storyService.getActiveStories());
    }

    @PostMapping
    public ResponseEntity<StoryResponse> createStory(
            @Valid @RequestBody CreateStoryRequest request,
            @AuthenticationPrincipal UUID userId) {
        return ResponseEntity.ok(storyService.createStory(request, userId));
    }
}

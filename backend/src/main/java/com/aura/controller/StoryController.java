package com.aura.controller;

import com.aura.dto.request.CreateStoryRequest;
import com.aura.dto.response.StoryResponse;
import com.aura.service.StoryService;
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
            @AuthenticationPrincipal UUID currentUserId) {
        return ResponseEntity.ok(storyService.createStory(request, currentUserId));
    }
}

package com.aura.post.service;

import com.aura.post.dto.request.CreateStoryRequest;
import com.aura.post.dto.response.StoryResponse;
import com.aura.post.entity.Story;
import com.aura.post.repository.StoryRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.time.Instant;
import java.util.List;
import java.util.UUID;

@Service
@RequiredArgsConstructor
public class StoryService {

    private final StoryRepository storyRepository;

    public List<StoryResponse> getActiveStories() {
        return storyRepository.findActiveStories(Instant.now()).stream()
                .map(this::toStoryResponse)
                .toList();
    }

    public StoryResponse createStory(CreateStoryRequest request, UUID userId) {
        Story story = Story.builder()
                .userId(userId)
                .mediaUrl(request.getMediaUrl())
                .mediaType(request.getMediaType())
                .expiresAt(Instant.now().plusSeconds(86400))
                .build();
        story = storyRepository.save(story);
        return toStoryResponse(story);
    }

    private StoryResponse toStoryResponse(Story story) {
        return StoryResponse.builder()
                .id(story.getId())
                .userId(story.getUserId())
                .mediaUrl(story.getMediaUrl())
                .mediaType(story.getMediaType())
                .expiresAt(story.getExpiresAt())
                .createdAt(story.getCreatedAt())
                .build();
    }
}

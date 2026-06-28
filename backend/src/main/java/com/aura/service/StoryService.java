package com.aura.service;

import com.aura.dto.request.CreateStoryRequest;
import com.aura.dto.response.StoryResponse;
import com.aura.dto.response.UserSummary;
import com.aura.entity.Story;
import com.aura.entity.User;
import com.aura.repository.StoryRepository;
import com.aura.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.time.Instant;
import java.util.List;
import java.util.UUID;

@Service
@RequiredArgsConstructor
public class StoryService {

    private final StoryRepository storyRepository;
    private final UserRepository userRepository;

    public List<StoryResponse> getActiveStories() {
        return storyRepository.findActiveStories(Instant.now())
                .stream()
                .map(this::toStoryResponse)
                .toList();
    }

    public StoryResponse createStory(CreateStoryRequest request, UUID userId) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("User not found"));

        Story story = Story.builder()
                .user(user)
                .mediaUrl(request.getMediaUrl())
                .mediaType(request.getMediaType())
                .expiresAt(Instant.now().plus(java.time.Duration.ofHours(24)))
                .build();

        story = storyRepository.save(story);
        return toStoryResponse(story);
    }

    private StoryResponse toStoryResponse(Story story) {
        return StoryResponse.builder()
                .id(story.getId())
                .user(UserSummary.builder()
                        .id(story.getUser().getId())
                        .username(story.getUser().getUsername())
                        .avatarUrl(story.getUser().getAvatarUrl())
                        .build())
                .mediaUrl(story.getMediaUrl())
                .mediaType(story.getMediaType())
                .expiresAt(story.getExpiresAt())
                .createdAt(story.getCreatedAt())
                .build();
    }
}

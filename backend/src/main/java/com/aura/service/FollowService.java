package com.aura.service;

import com.aura.dto.response.UserSummary;
import com.aura.entity.Follow;
import com.aura.entity.User;
import com.aura.repository.FollowRepository;
import com.aura.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Map;
import java.util.UUID;

@Service
@RequiredArgsConstructor
public class FollowService {

    private final FollowRepository followRepository;
    private final UserRepository userRepository;

    @Transactional
    public Map<String, Object> toggleFollow(UUID targetUserId, UUID currentUserId) {
        if (targetUserId.equals(currentUserId)) {
            throw new RuntimeException("Cannot follow yourself");
        }

        User target = userRepository.findById(targetUserId)
                .orElseThrow(() -> new RuntimeException("User not found"));

        var existing = followRepository.findByFollowerIdAndFollowingId(currentUserId, targetUserId);

        if (existing.isPresent()) {
            followRepository.delete(existing.get());
            return Map.of("following", false);
        } else {
            User current = userRepository.findById(currentUserId)
                    .orElseThrow(() -> new RuntimeException("User not found"));
            Follow follow = Follow.builder()
                    .follower(current)
                    .following(target)
                    .build();
            followRepository.save(follow);
            return Map.of("following", true);
        }
    }

    public List<UserSummary> getFollowers(UUID userId) {
        return followRepository.findByFollowingId(userId)
                .stream()
                .map(f -> UserSummary.builder()
                        .id(f.getFollower().getId())
                        .username(f.getFollower().getUsername())
                        .avatarUrl(f.getFollower().getAvatarUrl())
                        .build())
                .toList();
    }

    public List<UserSummary> getFollowing(UUID userId) {
        return followRepository.findByFollowerId(userId)
                .stream()
                .map(f -> UserSummary.builder()
                        .id(f.getFollowing().getId())
                        .username(f.getFollowing().getUsername())
                        .avatarUrl(f.getFollowing().getAvatarUrl())
                        .build())
                .toList();
    }
}

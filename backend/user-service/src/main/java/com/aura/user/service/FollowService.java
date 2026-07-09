package com.aura.user.service;

import com.aura.common.exception.BadRequestException;
import com.aura.common.exception.ResourceNotFoundException;
import com.aura.user.dto.response.FollowResponse;
import com.aura.user.dto.response.UserSummary;
import com.aura.user.entity.Follow;
import com.aura.user.entity.User;
import com.aura.user.mapper.UserMapper;
import com.aura.user.repository.FollowRepository;
import com.aura.user.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;
import java.util.UUID;

@Service
@RequiredArgsConstructor
public class FollowService {

    private final FollowRepository followRepository;
    private final UserRepository userRepository;
    private final UserMapper userMapper;

    public Map<String, Object> toggleFollow(UUID targetUserId, UUID currentUserId) {
        if (targetUserId.equals(currentUserId)) {
            throw new BadRequestException("Cannot follow yourself");
        }

        User targetUser = userRepository.findById(targetUserId)
                .orElseThrow(() -> new ResourceNotFoundException("User", "id", targetUserId));

        var existingFollow = followRepository.findByFollowerIdAndFollowingId(currentUserId, targetUserId);

        if (existingFollow.isPresent()) {
            followRepository.delete(existingFollow.get());
            return Map.of("following", false);
        } else {
            Follow follow = Follow.builder()
                    .follower(User.builder().id(currentUserId).build())
                    .following(targetUser)
                    .build();
            followRepository.save(follow);
            return Map.of("following", true);
        }
    }

    public List<UserSummary> getFollowers(UUID userId) {
        return followRepository.findByFollowingId(userId).stream()
                .map(follow -> userMapper.toSummary(follow.getFollower()))
                .toList();
    }

    public List<UserSummary> getFollowing(UUID userId) {
        return followRepository.findByFollowerId(userId).stream()
                .map(follow -> userMapper.toSummary(follow.getFollowing()))
                .toList();
    }
}

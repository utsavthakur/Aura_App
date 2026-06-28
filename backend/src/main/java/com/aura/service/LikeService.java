package com.aura.service;

import com.aura.dto.response.UserResponse;
import com.aura.dto.response.UserSummary;
import com.aura.entity.Like;
import com.aura.entity.Post;
import com.aura.entity.User;
import com.aura.repository.LikeRepository;
import com.aura.repository.PostRepository;
import com.aura.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Map;
import java.util.UUID;

@Service
@RequiredArgsConstructor
public class LikeService {

    private final LikeRepository likeRepository;
    private final PostRepository postRepository;
    private final UserRepository userRepository;

    @Transactional
    public Map<String, Object> toggleLike(UUID postId, UUID userId) {
        Post post = postRepository.findById(postId)
                .orElseThrow(() -> new RuntimeException("Post not found"));

        var existing = likeRepository.findByUserIdAndPostId(userId, postId);

        if (existing.isPresent()) {
            likeRepository.delete(existing.get());
            return Map.of("liked", false, "likeCount", post.getLikeCount());
        } else {
            User user = userRepository.findById(userId)
                    .orElseThrow(() -> new RuntimeException("User not found"));
            Like like = Like.builder()
                    .user(user)
                    .post(post)
                    .build();
            likeRepository.save(like);
            return Map.of("liked", true, "likeCount", post.getLikeCount());
        }
    }

    public List<UserSummary> getPostLikes(UUID postId) {
        return likeRepository.findByPostId(postId)
                .stream()
                .map(like -> UserSummary.builder()
                        .id(like.getUser().getId())
                        .username(like.getUser().getUsername())
                        .avatarUrl(like.getUser().getAvatarUrl())
                        .build())
                .toList();
    }
}

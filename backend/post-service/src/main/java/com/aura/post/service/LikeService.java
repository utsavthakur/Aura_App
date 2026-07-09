package com.aura.post.service;

import com.aura.common.exception.ResourceNotFoundException;
import com.aura.post.dto.response.LikeResponse;
import com.aura.post.entity.Like;
import com.aura.post.repository.LikeRepository;
import com.aura.post.repository.PostRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.Map;
import java.util.UUID;

@Service
@RequiredArgsConstructor
public class LikeService {

    private final LikeRepository likeRepository;
    private final PostRepository postRepository;

    public LikeResponse toggleLike(UUID postId, UUID userId) {
        if (!postRepository.existsById(postId)) {
            throw new ResourceNotFoundException("Post", "id", postId);
        }

        var existingLike = likeRepository.findByUserIdAndPostId(userId, postId);

        if (existingLike.isPresent()) {
            likeRepository.delete(existingLike.get());
        } else {
            Like like = Like.builder()
                    .userId(userId)
                    .postId(postId)
                    .build();
            likeRepository.save(like);
        }

        return LikeResponse.builder()
                .liked(existingLike.isEmpty())
                .likeCount((int) likeRepository.countByPostId(postId))
                .build();
    }
}

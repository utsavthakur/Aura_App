package com.aura.mapper;

import com.aura.dto.response.PostResponse;
import com.aura.entity.Post;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Component;

@Component
@RequiredArgsConstructor
public class PostMapper {

    private final UserMapper userMapper;

    public PostResponse toResponse(Post post, boolean likedByMe) {
        return PostResponse.builder()
                .id(post.getId())
                .user(userMapper.toSummary(post.getUser()))
                .caption(post.getCaption())
                .content(post.getCaption())
                .mediaUrl(post.getMediaUrl())
                .mediaType(post.getMediaType())
                .location(post.getLocation())
                .likeCount(post.getLikeCount())
                .commentCount(post.getCommentCount())
                .createdAt(post.getCreatedAt())
                .likedByMe(likedByMe)
                .build();
    }
}

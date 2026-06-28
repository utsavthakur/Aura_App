package com.aura.service;

import com.aura.dto.response.PagedResponse;
import com.aura.dto.response.PostResponse;
import com.aura.dto.response.UserSummary;
import com.aura.entity.Post;
import com.aura.repository.LikeRepository;
import com.aura.repository.PostRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.PageRequest;
import org.springframework.stereotype.Service;

import java.util.UUID;

@Service
@RequiredArgsConstructor
public class ExploreService {

    private final PostRepository postRepository;
    private final LikeRepository likeRepository;

    public PagedResponse<PostResponse> getExploreFeed(int page, int size, UUID currentUserId) {
        PageRequest pr = PageRequest.of(page, size);
        var postPage = postRepository.findAllByOrderByCreatedAtDesc(pr);

        return PagedResponse.<PostResponse>builder()
                .content(postPage.getContent().stream()
                        .map(p -> toPostResponse(p, currentUserId))
                        .toList())
                .page(page)
                .size(size)
                .totalElements(postPage.getTotalElements())
                .totalPages(postPage.getTotalPages())
                .last(postPage.isLast())
                .build();
    }

    public PagedResponse<PostResponse> search(String query, int page, int size, UUID currentUserId) {
        PageRequest pr = PageRequest.of(page, size);
        var postPage = postRepository.findByCaptionContainingIgnoreCase(query, pr);

        return PagedResponse.<PostResponse>builder()
                .content(postPage.getContent().stream()
                        .map(p -> toPostResponse(p, currentUserId))
                        .toList())
                .page(page)
                .size(size)
                .totalElements(postPage.getTotalElements())
                .totalPages(postPage.getTotalPages())
                .last(postPage.isLast())
                .build();
    }

    private PostResponse toPostResponse(Post post, UUID currentUserId) {
        boolean likedByMe = currentUserId != null &&
                likeRepository.existsByUserIdAndPostId(currentUserId, post.getId());

        return PostResponse.builder()
                .id(post.getId())
                .user(UserSummary.builder()
                        .id(post.getUser().getId())
                        .username(post.getUser().getUsername())
                        .avatarUrl(post.getUser().getAvatarUrl())
                        .build())
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

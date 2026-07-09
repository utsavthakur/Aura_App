package com.aura.post.service;

import com.aura.common.dto.response.PagedResponse;
import com.aura.common.exception.ResourceNotFoundException;
import com.aura.post.dto.request.CreatePostRequest;
import com.aura.post.dto.response.PostResponse;
import com.aura.post.entity.Post;
import com.aura.post.repository.LikeRepository;
import com.aura.post.repository.PostRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.stereotype.Service;

import java.util.UUID;

@Service
@RequiredArgsConstructor
public class PostService {

    private final PostRepository postRepository;
    private final LikeRepository likeRepository;

    public PagedResponse<PostResponse> getFeed(int page, int size, UUID currentUserId) {
        Page<Post> posts = postRepository.findAllByOrderByCreatedAtDesc(PageRequest.of(page, size));
        return toPagedResponse(posts, currentUserId);
    }

    public PostResponse createPost(CreatePostRequest request, UUID userId) {
        Post post = Post.builder()
                .userId(userId)
                .caption(request.getCaption())
                .mediaUrl(request.getMediaUrl())
                .mediaType(request.getMediaType())
                .location(request.getLocation())
                .build();
        post = postRepository.save(post);
        return toPostResponse(post, false);
    }

    public void deletePost(UUID postId, UUID userId) {
        Post post = postRepository.findById(postId)
                .orElseThrow(() -> new ResourceNotFoundException("Post", "id", postId));
        if (!post.getUserId().equals(userId)) {
            throw new com.aura.common.exception.UnauthorizedException("Not authorized to delete this post");
        }
        postRepository.delete(post);
    }

    public PostResponse getPost(UUID postId, UUID currentUserId) {
        Post post = postRepository.findById(postId)
                .orElseThrow(() -> new ResourceNotFoundException("Post", "id", postId));
        boolean likedByMe = likeRepository.existsByUserIdAndPostId(currentUserId, postId);
        return toPostResponse(post, likedByMe);
    }

    public PagedResponse<PostResponse> getUserPosts(UUID userId, int page, int size, UUID currentUserId) {
        Page<Post> posts = postRepository.findByUserIdOrderByCreatedAtDesc(userId, PageRequest.of(page, size));
        return toPagedResponse(posts, currentUserId);
    }

    private PostResponse toPostResponse(Post post, boolean likedByMe) {
        return PostResponse.builder()
                .id(post.getId())
                .userId(post.getUserId())
                .caption(post.getCaption())
                .mediaUrl(post.getMediaUrl())
                .mediaType(post.getMediaType())
                .location(post.getLocation())
                .likeCount(post.getLikeCount())
                .commentCount(post.getCommentCount())
                .createdAt(post.getCreatedAt())
                .likedByMe(likedByMe)
                .build();
    }

    private PagedResponse<PostResponse> toPagedResponse(Page<Post> page, UUID currentUserId) {
        var content = page.getContent().stream()
                .map(post -> toPostResponse(post, likeRepository.existsByUserIdAndPostId(currentUserId, post.getId())))
                .toList();
        return PagedResponse.<PostResponse>builder()
                .content(content)
                .page(page.getNumber())
                .size(page.getSize())
                .totalElements(page.getTotalElements())
                .totalPages(page.getTotalPages())
                .last(page.isLast())
                .build();
    }
}

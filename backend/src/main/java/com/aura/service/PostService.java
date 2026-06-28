package com.aura.service;

import com.aura.dto.request.CreatePostRequest;
import com.aura.dto.response.PagedResponse;
import com.aura.dto.response.PostResponse;
import com.aura.dto.response.UserSummary;
import com.aura.entity.Post;
import com.aura.entity.User;
import com.aura.repository.LikeRepository;
import com.aura.repository.PostRepository;
import com.aura.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.UUID;

@Service
@RequiredArgsConstructor
public class PostService {

    private final PostRepository postRepository;
    private final UserRepository userRepository;
    private final LikeRepository likeRepository;

    public PagedResponse<PostResponse> getFeed(int page, int size, UUID currentUserId) {
        PageRequest pr = PageRequest.of(page, size);
        Page<Post> postPage = postRepository.findAllByOrderByCreatedAtDesc(pr);

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

    public PostResponse createPost(CreatePostRequest request, UUID userId) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("User not found"));

        Post post = Post.builder()
                .user(user)
                .caption(request.getCaption())
                .mediaUrl(request.getMediaUrl())
                .mediaType(request.getMediaType())
                .location(request.getLocation())
                .build();

        post = postRepository.save(post);
        return toPostResponse(post, userId);
    }

    @Transactional
    public void deletePost(UUID postId, UUID userId) {
        Post post = postRepository.findById(postId)
                .orElseThrow(() -> new RuntimeException("Post not found"));
        if (!post.getUser().getId().equals(userId)) {
            throw new RuntimeException("Not authorized to delete this post");
        }
        postRepository.delete(post);
    }

    public PostResponse getPost(UUID postId, UUID currentUserId) {
        Post post = postRepository.findById(postId)
                .orElseThrow(() -> new RuntimeException("Post not found"));
        return toPostResponse(post, currentUserId);
    }

    public PagedResponse<PostResponse> getUserPosts(UUID userId, int page, int size, UUID currentUserId) {
        PageRequest pr = PageRequest.of(page, size);
        Page<Post> postPage = postRepository.findByUserIdOrderByCreatedAtDesc(userId, pr);

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

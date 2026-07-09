package com.aura.post.service;

import com.aura.common.exception.ResourceNotFoundException;
import com.aura.common.exception.UnauthorizedException;
import com.aura.post.dto.request.CreateCommentRequest;
import com.aura.post.dto.response.CommentResponse;
import com.aura.post.entity.Comment;
import com.aura.post.repository.CommentRepository;
import com.aura.post.repository.PostRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.UUID;

@Service
@RequiredArgsConstructor
public class CommentService {

    private final CommentRepository commentRepository;
    private final PostRepository postRepository;

    public List<CommentResponse> getPostComments(UUID postId) {
        return commentRepository.findByPostIdOrderByCreatedAtAsc(postId).stream()
                .map(this::toCommentResponse)
                .toList();
    }

    public CommentResponse createComment(UUID postId, CreateCommentRequest request, UUID userId) {
        if (!postRepository.existsById(postId)) {
            throw new ResourceNotFoundException("Post", "id", postId);
        }

        Comment comment = Comment.builder()
                .userId(userId)
                .postId(postId)
                .content(request.getContent())
                .build();
        comment = commentRepository.save(comment);
        return toCommentResponse(comment);
    }

    public void deleteComment(UUID commentId, UUID userId) {
        Comment comment = commentRepository.findById(commentId)
                .orElseThrow(() -> new ResourceNotFoundException("Comment", "id", commentId));
        if (!comment.getUserId().equals(userId)) {
            throw new UnauthorizedException("Not authorized to delete this comment");
        }
        commentRepository.delete(comment);
    }

    private CommentResponse toCommentResponse(Comment comment) {
        return CommentResponse.builder()
                .id(comment.getId())
                .userId(comment.getUserId())
                .postId(comment.getPostId())
                .content(comment.getContent())
                .createdAt(comment.getCreatedAt())
                .build();
    }
}

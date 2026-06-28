package com.aura.repository;

import com.aura.entity.Comment;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;
import java.util.UUID;

public interface CommentRepository extends JpaRepository<Comment, UUID> {
    List<Comment> findByPostIdOrderByCreatedAtAsc(UUID postId);
    long countByPostId(UUID postId);
    void deleteByIdAndUserId(UUID id, UUID userId);
}

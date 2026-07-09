package com.aura.post.repository;

import com.aura.post.entity.Post;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.UUID;

public interface PostRepository extends JpaRepository<Post, UUID> {
    Page<Post> findAllByOrderByCreatedAtDesc(Pageable pageable);
    Page<Post> findByUserIdOrderByCreatedAtDesc(UUID userId, Pageable pageable);
    Page<Post> findByCaptionContainingIgnoreCase(String query, Pageable pageable);
    long countByUserId(UUID userId);
}

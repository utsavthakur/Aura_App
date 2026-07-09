package com.aura.post.repository;

import com.aura.post.entity.Like;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;
import java.util.Optional;
import java.util.UUID;

public interface LikeRepository extends JpaRepository<Like, UUID> {
    Optional<Like> findByUserIdAndPostId(UUID userId, UUID postId);
    List<Like> findByPostId(UUID postId);
    boolean existsByUserIdAndPostId(UUID userId, UUID postId);
    long countByPostId(UUID postId);
}

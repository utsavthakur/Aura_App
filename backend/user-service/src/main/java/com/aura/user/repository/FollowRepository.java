package com.aura.user.repository;

import com.aura.user.entity.Follow;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;
import java.util.Optional;
import java.util.UUID;

public interface FollowRepository extends JpaRepository<Follow, UUID> {
    Optional<Follow> findByFollowerIdAndFollowingId(UUID followerId, UUID followingId);
    List<Follow> findByFollowerId(UUID followerId);
    List<Follow> findByFollowingId(UUID followingId);
    long countByFollowerId(UUID followerId);
    long countByFollowingId(UUID followingId);
    boolean existsByFollowerIdAndFollowingId(UUID followerId, UUID followingId);
}

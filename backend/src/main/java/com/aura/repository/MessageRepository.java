package com.aura.repository;

import com.aura.entity.Message;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import java.util.List;
import java.util.UUID;

public interface MessageRepository extends JpaRepository<Message, UUID> {
    @Query("SELECT m FROM Message m WHERE (m.sender.id = :userId1 AND m.receiver.id = :userId2) OR (m.sender.id = :userId2 AND m.receiver.id = :userId1) ORDER BY m.createdAt ASC")
    List<Message> findConversation(UUID userId1, UUID userId2);

    @Query("SELECT m FROM Message m WHERE m.receiver.id = :userId OR m.sender.id = :userId ORDER BY m.createdAt DESC")
    Page<Message> findRecentMessages(UUID userId, Pageable pageable);

    long countByReceiverIdAndIsReadFalse(UUID receiverId);
}

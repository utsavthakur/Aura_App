package com.aura.chat.repository;

import com.aura.chat.entity.Message;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import java.util.List;
import java.util.UUID;

public interface MessageRepository extends JpaRepository<Message, UUID> {

    @Query("SELECT m FROM Message m WHERE (m.senderId = :userId1 AND m.receiverId = :userId2) OR (m.senderId = :userId2 AND m.receiverId = :userId1) ORDER BY m.createdAt ASC")
    List<Message> findConversation(UUID userId1, UUID userId2);

    @Query("SELECT m FROM Message m WHERE m.receiverId = :userId OR m.senderId = :userId ORDER BY m.createdAt DESC")
    Page<Message> findRecentMessages(UUID userId, Pageable pageable);

    long countByReceiverIdAndIsReadFalse(UUID receiverId);
}

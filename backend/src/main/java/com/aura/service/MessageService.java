package com.aura.service;

import com.aura.dto.request.SendMessageRequest;
import com.aura.dto.response.MessageResponse;
import com.aura.dto.response.UserSummary;
import com.aura.entity.Message;
import com.aura.entity.User;
import com.aura.repository.MessageRepository;
import com.aura.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.UUID;

@Service
@RequiredArgsConstructor
public class MessageService {

    private final MessageRepository messageRepository;
    private final UserRepository userRepository;

    public List<MessageResponse> getConversation(UUID userId1, UUID userId2) {
        return messageRepository.findConversation(userId1, userId2)
                .stream()
                .map(this::toMessageResponse)
                .toList();
    }

    public MessageResponse sendMessage(SendMessageRequest request, UUID senderId) {
        User sender = userRepository.findById(senderId)
                .orElseThrow(() -> new RuntimeException("Sender not found"));
        User receiver = userRepository.findById(request.getReceiverId())
                .orElseThrow(() -> new RuntimeException("Receiver not found"));

        Message message = Message.builder()
                .sender(sender)
                .receiver(receiver)
                .content(request.getContent())
                .build();

        message = messageRepository.save(message);
        return toMessageResponse(message);
    }

    @Transactional
    public void markAsRead(UUID messageId) {
        Message message = messageRepository.findById(messageId)
                .orElseThrow(() -> new RuntimeException("Message not found"));
        message.setRead(true);
        messageRepository.save(message);
    }

    public long getUnreadCount(UUID userId) {
        return messageRepository.countByReceiverIdAndIsReadFalse(userId);
    }

    private MessageResponse toMessageResponse(Message message) {
        return MessageResponse.builder()
                .id(message.getId())
                .sender(UserSummary.builder()
                        .id(message.getSender().getId())
                        .username(message.getSender().getUsername())
                        .avatarUrl(message.getSender().getAvatarUrl())
                        .build())
                .receiver(UserSummary.builder()
                        .id(message.getReceiver().getId())
                        .username(message.getReceiver().getUsername())
                        .avatarUrl(message.getReceiver().getAvatarUrl())
                        .build())
                .content(message.getContent())
                .isRead(message.isRead())
                .createdAt(message.getCreatedAt())
                .build();
    }
}

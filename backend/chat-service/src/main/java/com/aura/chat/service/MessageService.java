package com.aura.chat.service;

import com.aura.chat.dto.request.SendMessageRequest;
import com.aura.chat.dto.response.MessageResponse;
import com.aura.chat.entity.Message;
import com.aura.chat.repository.MessageRepository;
import com.aura.common.exception.ResourceNotFoundException;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.PageRequest;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.UUID;

@Service
@RequiredArgsConstructor
public class MessageService {

    private final MessageRepository messageRepository;

    public List<MessageResponse> getConversation(UUID userId1, UUID userId2) {
        return messageRepository.findConversation(userId1, userId2).stream()
                .map(this::toMessageResponse)
                .toList();
    }

    public MessageResponse sendMessage(SendMessageRequest request, UUID senderId) {
        Message message = Message.builder()
                .senderId(senderId)
                .receiverId(request.getReceiverId())
                .content(request.getContent())
                .build();
        message = messageRepository.save(message);
        return toMessageResponse(message);
    }

    public void markAsRead(UUID messageId) {
        Message message = messageRepository.findById(messageId)
                .orElseThrow(() -> new ResourceNotFoundException("Message", "id", messageId));
        message.setRead(true);
        messageRepository.save(message);
    }

    public long getUnreadCount(UUID userId) {
        return messageRepository.countByReceiverIdAndIsReadFalse(userId);
    }

    private MessageResponse toMessageResponse(Message message) {
        return MessageResponse.builder()
                .id(message.getId())
                .senderId(message.getSenderId())
                .receiverId(message.getReceiverId())
                .content(message.getContent())
                .isRead(message.isRead())
                .createdAt(message.getCreatedAt())
                .build();
    }
}

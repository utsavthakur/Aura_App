package com.aura.chat.controller;

import com.aura.chat.dto.request.SendMessageRequest;
import com.aura.chat.dto.response.MessageResponse;
import com.aura.chat.service.MessageService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;
import java.util.UUID;

@RestController
@RequestMapping("/api/messages")
@RequiredArgsConstructor
public class MessageController {

    private final MessageService messageService;

    @GetMapping
    public ResponseEntity<List<MessageResponse>> getConversation(
            @RequestParam UUID userId,
            @AuthenticationPrincipal UUID currentUserId) {
        return ResponseEntity.ok(messageService.getConversation(currentUserId, userId));
    }

    @PostMapping
    public ResponseEntity<MessageResponse> sendMessage(
            @Valid @RequestBody SendMessageRequest request,
            @AuthenticationPrincipal UUID senderId) {
        return ResponseEntity.ok(messageService.sendMessage(request, senderId));
    }

    @PutMapping("/{id}/read")
    public ResponseEntity<Void> markAsRead(@PathVariable UUID id) {
        messageService.markAsRead(id);
        return ResponseEntity.ok().build();
    }

    @GetMapping("/unread")
    public ResponseEntity<Map<String, Long>> getUnreadCount(@AuthenticationPrincipal UUID userId) {
        return ResponseEntity.ok(Map.of("count", messageService.getUnreadCount(userId)));
    }
}

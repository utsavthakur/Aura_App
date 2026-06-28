package com.aura.controller;

import com.aura.dto.request.SendMessageRequest;
import com.aura.dto.response.MessageResponse;
import com.aura.service.MessageService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;

import java.util.List;
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
            @AuthenticationPrincipal UUID currentUserId) {
        return ResponseEntity.ok(messageService.sendMessage(request, currentUserId));
    }

    @PutMapping("/{id}/read")
    public ResponseEntity<Void> markAsRead(@PathVariable UUID id) {
        messageService.markAsRead(id);
        return ResponseEntity.noContent().build();
    }

    @GetMapping("/unread")
    public ResponseEntity<Long> getUnreadCount(@AuthenticationPrincipal UUID currentUserId) {
        return ResponseEntity.ok(messageService.getUnreadCount(currentUserId));
    }
}

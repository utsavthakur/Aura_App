package com.aura.controller;

import com.aura.dto.response.NotificationResponse;
import com.aura.service.NotificationService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.UUID;

@RestController
@RequestMapping("/api/notifications")
@RequiredArgsConstructor
public class NotificationController {

    private final NotificationService notificationService;

    @GetMapping
    public ResponseEntity<List<NotificationResponse>> getNotifications(
            @AuthenticationPrincipal UUID currentUserId) {
        return ResponseEntity.ok(notificationService.getUserNotifications(currentUserId));
    }

    @PutMapping("/{id}/read")
    public ResponseEntity<Void> markAsRead(@PathVariable UUID id) {
        notificationService.markAsRead(id);
        return ResponseEntity.noContent().build();
    }

    @PutMapping("/read-all")
    public ResponseEntity<Void> markAllAsRead(@AuthenticationPrincipal UUID currentUserId) {
        notificationService.markAllAsRead(currentUserId);
        return ResponseEntity.noContent().build();
    }

    @GetMapping("/unread")
    public ResponseEntity<Long> getUnreadCount(@AuthenticationPrincipal UUID currentUserId) {
        return ResponseEntity.ok(notificationService.getUnreadCount(currentUserId));
    }
}

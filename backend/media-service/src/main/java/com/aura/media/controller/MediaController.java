package com.aura.media.controller;

import com.aura.media.dto.response.MediaResponse;
import com.aura.media.service.MediaService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.util.UUID;

@RestController
@RequestMapping("/api/media")
@RequiredArgsConstructor
public class MediaController {

    private final MediaService mediaService;

    @PostMapping("/upload")
    public ResponseEntity<MediaResponse> upload(
            @RequestParam("file") MultipartFile file,
            @AuthenticationPrincipal UUID userId) {
        return ResponseEntity.ok(mediaService.upload(file));
    }
}

package com.aura.media.service;

import com.aura.media.dto.response.MediaResponse;
import com.aura.media.storage.MinioService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

@Service
@RequiredArgsConstructor
public class MediaService {

    private final MinioService minioService;

    public MediaResponse upload(MultipartFile file) {
        String url = minioService.uploadFile(file);
        return MediaResponse.builder()
                .url(url)
                .fileName(file.getOriginalFilename())
                .contentType(file.getContentType())
                .size(file.getSize())
                .build();
    }
}

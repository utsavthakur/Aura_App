package com.aura.media.dto.response;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;

@Data
@AllArgsConstructor
@Builder
public class MediaResponse {
    private String url;
    private String fileName;
    private String contentType;
    private long size;
}

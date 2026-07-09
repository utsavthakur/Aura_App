package com.aura.post.dto.response;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;

@Data
@AllArgsConstructor
@Builder
public class LikeResponse {
    private boolean liked;
    private int likeCount;
}

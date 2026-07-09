package com.aura.post.service;

import com.aura.common.dto.response.PagedResponse;
import com.aura.post.dto.response.PostResponse;
import com.aura.post.repository.PostRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.PageRequest;
import org.springframework.stereotype.Service;

import java.util.UUID;

@Service
@RequiredArgsConstructor
public class ExploreService {

    private final PostRepository postRepository;
    private final PostService postService;

    public PagedResponse<PostResponse> getExploreFeed(int page, int size, UUID currentUserId) {
        var posts = postRepository.findAllByOrderByCreatedAtDesc(PageRequest.of(page, size));
        return postService.getFeed(page, size, currentUserId);
    }

    public PagedResponse<PostResponse> search(String query, int page, int size, UUID currentUserId) {
        var posts = postRepository.findByCaptionContainingIgnoreCase(query, PageRequest.of(page, size));
        var content = posts.getContent().stream()
                .map(post -> postService.getPost(post.getId(), currentUserId))
                .toList();
        return PagedResponse.<PostResponse>builder()
                .content(content)
                .page(posts.getNumber())
                .size(posts.getSize())
                .totalElements(posts.getTotalElements())
                .totalPages(posts.getTotalPages())
                .last(posts.isLast())
                .build();
    }
}

package com.aura.user.service;

import com.aura.common.exception.BadRequestException;
import com.aura.common.exception.ResourceNotFoundException;
import com.aura.user.dto.request.CreateUserRequest;
import com.aura.user.dto.request.UpdateProfileRequest;
import com.aura.user.dto.response.UserResponse;
import com.aura.user.dto.response.UserSummary;
import com.aura.user.entity.User;
import com.aura.user.mapper.UserMapper;
import com.aura.user.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.UUID;

@Service
@RequiredArgsConstructor
public class UserService {

    private final UserRepository userRepository;
    private final UserMapper userMapper;

    public UserResponse getProfile(UUID userId) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new ResourceNotFoundException("User", "id", userId));
        return userMapper.toResponse(user, 0, 0, 0);
    }

    public UserResponse updateProfile(UUID userId, UpdateProfileRequest request) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new ResourceNotFoundException("User", "id", userId));

        if (request.getUsername() != null) {
            if (!request.getUsername().equals(user.getUsername()) &&
                    userRepository.existsByUsername(request.getUsername())) {
                throw new BadRequestException("Username already taken");
            }
            user.setUsername(request.getUsername());
        }
        if (request.getBio() != null) {
            user.setBio(request.getBio());
        }
        if (request.getAvatarUrl() != null) {
            user.setAvatarUrl(request.getAvatarUrl());
        }

        user = userRepository.save(user);
        return userMapper.toResponse(user, 0, 0, 0);
    }

    public UserSummary getUserSummary(UUID userId) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new ResourceNotFoundException("User", "id", userId));
        return userMapper.toSummary(user);
    }

    public void createUser(CreateUserRequest request) {
        if (userRepository.existsById(request.getId())) {
            return;
        }
        User user = User.builder()
                .id(request.getId())
                .username(request.getUsername())
                .email(request.getEmail())
                .bio("")
                .build();
        userRepository.save(user);
    }
}

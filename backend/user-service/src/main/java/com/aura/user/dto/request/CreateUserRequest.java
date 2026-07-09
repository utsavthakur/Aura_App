package com.aura.user.dto.request;

import lombok.Data;
import java.util.UUID;

@Data
public class CreateUserRequest {
    private UUID id;
    private String username;
    private String email;
}

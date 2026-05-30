package com.example.model;

import lombok.AllArgsConstructor;
import lombok.Data;

@Data
@AllArgsConstructor
public class HealthStatus {
    private String status;
    private String message;
    private String version;
    private String timestamp;
}

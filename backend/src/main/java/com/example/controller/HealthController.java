package com.example.controller;

import com.example.model.HealthStatus;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.time.LocalDateTime;

@RestController
@RequestMapping("/api/v1")
@Tag(name = "Health Check", description = "Application health and status endpoints")
public class HealthController {
    
    @GetMapping("/health")
    @Operation(summary = "Health check", description = "Check if the application is running")
    public ResponseEntity<HealthStatus> health() {
        HealthStatus status = new HealthStatus(
            "UP",
            "Application is running",
            "1.0.0",
            LocalDateTime.now().toString()
        );
        return ResponseEntity.ok(status);
    }
    
    @GetMapping("/info")
    @Operation(summary = "Application info", description = "Get application information")
    public ResponseEntity<?> info() {
        return ResponseEntity.ok(java.util.Map.of(
            "name", "Krishna DevOps Multi-Service API",
            "version", "1.0.0",
            "description", "Production-ready REST API with database integration",
            "timestamp", LocalDateTime.now()
        ));
    }
}

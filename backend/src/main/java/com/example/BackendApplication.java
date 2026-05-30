package com.example;

import io.swagger.v3.oas.annotations.OpenAPIDefinition;
import io.swagger.v3.oas.annotations.info.Contact;
import io.swagger.v3.oas.annotations.info.Info;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
@OpenAPIDefinition(
    info = @Info(
        title = "Krishna DevOps Multi-Service API",
        version = "1.0.0",
        description = "Production-ready REST API with database integration",
        contact = @Contact(
            name = "Krishna DevOps Training",
            url = "https://github.com/krishnadevopstraining-tech"
        )
    )
)
public class BackendApplication {

    public static void main(String[] args) {
        SpringApplication.run(BackendApplication.class, args);
    }

}

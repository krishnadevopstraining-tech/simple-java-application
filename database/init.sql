-- Initial database schema
CREATE TABLE IF NOT EXISTS users (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    phone VARCHAR(20) NOT NULL,
    message TEXT,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Create indexes
CREATE INDEX IF NOT EXISTS idx_email ON users(email);
CREATE INDEX IF NOT EXISTS idx_created_at ON users(created_at DESC);

-- Insert sample data
INSERT INTO users (name, email, phone, message) VALUES
('John Doe', 'john@example.com', '+1-123-456-7890', 'Hello from Kubernetes'),
('Jane Smith', 'jane@example.com', '+1-098-765-4321', 'Production-ready application')
ON CONFLICT (email) DO NOTHING;

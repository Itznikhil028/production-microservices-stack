CREATE TABLE IF NOT EXISTS users (
    id SERIAL PRIMARY KEY,
    username VARCHAR(50) NOT NULL,
    role VARCHAR(20) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO users (username, role) VALUES 
('nikhil_devops', 'Lead Engineer'),
('cloud_admin', 'SRE Specialist')
ON CONFLICT DO NOTHING;

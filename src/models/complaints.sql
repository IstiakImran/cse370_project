-- Create 'complaints' table
CREATE TABLE complaints (
    complaint_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    request_id INT,
    description TEXT,
    status ENUM(
        'pending',
        'resolved',
        'dismissed'
    ),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users (user_id),
    FOREIGN KEY (request_id) REFERENCES ride_requests (request_id)
);

SELECT * FROM complaints WHERE user_id = 1;
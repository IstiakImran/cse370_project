-- Create 'ride_requests' table

USE splitGo;

CREATE TABLE ride_requests (
    request_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT, -- The user who created the ride request
    origin VARCHAR(255),
    destination VARCHAR(255),
    total_fare DECIMAL(10, 2),
    total_passengers INT,
    total_accepted INT,
    ride_time TIMESTAMP,
    status ENUM(
        'pending',
        'accepted',
        'completed',
        'cancelled'
    ),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users (user_id)
);

CREATE TABLE ride_participants (
    request_id INT,
    passenger_id INT,
    PRIMARY KEY (request_id, passenger_id),
    FOREIGN KEY (request_id) REFERENCES ride_requests (request_id),
    FOREIGN KEY (passenger_id) REFERENCES users (user_id)
);

SELECT rr.request_id, rr.origin, rr.destination, rr.total_fare, rp.passenger_id, rp.share_of_fare
FROM
    ride_requests rr
    JOIN ride_participants rp ON rr.request_id = rp.request_id
WHERE
    rr.request_id = 1;

UPDATE ride_requests SET status = 'accepted' WHERE request_id = 1;
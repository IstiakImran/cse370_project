-- Create User table
CREATE TABLE User (
    user_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    phone VARCHAR(15),
    address VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    is_verified BOOLEAN DEFAULT FALSE,
    verification_type ENUM('NID', 'Student ID'),
    video_verification_status BOOLEAN DEFAULT FALSE,
    account_status ENUM('active', 'banned') DEFAULT 'active'
);

-- Create Driver table
CREATE TABLE Driver (
    driver_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT,
    vehicle_details VARCHAR(255),
    license_number VARCHAR(50) UNIQUE NOT NULL,
    insurance_details VARCHAR(255),
    driver_rating DECIMAL(3, 2),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES User(user_id)
);

-- Create Ride_Request table
CREATE TABLE Ride_Request (
    request_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT,
    origin VARCHAR(255) NOT NULL,
    destination VARCHAR(255) NOT NULL,
    ride_time TIMESTAMP,
    ride_type ENUM('individual', 'shared') DEFAULT 'individual',
    status ENUM('pending', 'accepted', 'cancelled', 'completed') DEFAULT 'pending',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES User(user_id)
);

-- Create Ride table
CREATE TABLE Ride (
    ride_id INT PRIMARY KEY AUTO_INCREMENT,
    request_id INT,
    driver_id INT,
    ride_status ENUM('ongoing', 'completed', 'cancelled') DEFAULT 'ongoing',
    actual_start_time TIMESTAMP,
    actual_end_time TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (request_id) REFERENCES Ride_Request(request_id),
    FOREIGN KEY (driver_id) REFERENCES Driver(driver_id)
);

-- Create Conversation table
CREATE TABLE Conversation (
    conversation_id INT PRIMARY KEY AUTO_INCREMENT,
    ride_id INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (ride_id) REFERENCES Ride(ride_id)
);

-- Create Message table
CREATE TABLE Message (
    message_id INT PRIMARY KEY AUTO_INCREMENT,
    conversation_id INT,
    sender_id INT,
    receiver_id INT,
    message_text TEXT,
    sent_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (conversation_id) REFERENCES Conversation(conversation_id),
    FOREIGN KEY (sender_id) REFERENCES User(user_id),
    FOREIGN KEY (receiver_id) REFERENCES User(user_id)
);

-- Create Complaint table
CREATE TABLE Complaint (
    complaint_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT,
    ride_id INT,
    complaint_text TEXT,
    status ENUM('open', 'resolved') DEFAULT 'open',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES User(user_id),
    FOREIGN KEY (ride_id) REFERENCES Ride(ride_id)
);

-- Create Verification table
CREATE TABLE Verification (
    verification_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT,
    document_type ENUM('NID', 'Passport', 'Driver License'),
    document_number VARCHAR(50),
    document_image BLOB,
    verification_status ENUM('pending', 'verified', 'rejected') DEFAULT 'pending',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES User(user_id)
);

-- Create Cancellation table
CREATE TABLE Cancellation (
    cancellation_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT,
    ride_id INT,
    cancellation_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    reason TEXT,
    FOREIGN KEY (user_id) REFERENCES User(user_id),
    FOREIGN KEY (ride_id) REFERENCES Ride(ride_id)
);

-- Create Rating table
CREATE TABLE Rating (
    rating_id INT PRIMARY KEY AUTO_INCREMENT,
    ride_id INT,
    rater_id INT,
    ratee_id INT,
    rating DECIMAL(3, 2) CHECK (rating >= 1.0 AND rating <= 5.0),
    review TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (ride_id) REFERENCES Ride(ride_id),
    FOREIGN KEY (rater_id) REFERENCES User(user_id),
    FOREIGN KEY (ratee_id) REFERENCES User(user_id)
);

-- Create Payment table
CREATE TABLE Payment (
    payment_id INT PRIMARY KEY AUTO_INCREMENT,
    ride_id INT,
    user_id INT,
    amount DECIMAL(10, 2),
    payment_method ENUM('credit_card', 'debit_card', 'paypal', 'cash'),
    payment_status ENUM('pending', 'completed', 'failed') DEFAULT 'pending',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (ride_id) REFERENCES Ride(ride_id),
    FOREIGN KEY (user_id) REFERENCES User(user_id)
);

-- Create Location table
CREATE TABLE Location (
    location_id INT PRIMARY KEY AUTO_INCREMENT,
    ride_id INT,
    latitude DECIMAL(10, 8),
    longitude DECIMAL(11, 8),
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (ride_id) REFERENCES Ride(ride_id)
);

-- Create Location table
CREATE TABLE Location (
    location_id INT PRIMARY KEY AUTO_INCREMENT,
    ride_id INT,
    latitude DECIMAL(10, 8),
    longitude DECIMAL(11, 8),
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (ride_id) REFERENCES Ride(ride_id)
);

-- Create Promotion table
CREATE TABLE Promotion (
    promotion_id INT PRIMARY KEY AUTO_INCREMENT,
    code VARCHAR(50) UNIQUE NOT NULL,
    discount_percentage DECIMAL(5, 2),
    start_date DATE,
    end_date DATE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create Ride_Sharing table
CREATE TABLE Ride_Sharing (
    ride_sharing_id INT PRIMARY KEY AUTO_INCREMENT,
    ride_id INT,
    user_id INT,
    pickup_location VARCHAR(255),
    dropoff_location VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (ride_id) REFERENCES Ride(ride_id),
    FOREIGN KEY (user_id) REFERENCES User(user_id)
);

-- Create Notification table
CREATE TABLE Notification (
    notification_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT,
    message TEXT,
    type ENUM('ride_request', 'ride_status', 'promotion', 'system'),
    is_read BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES User(user_id)
);

-- Create Audit_Log table
CREATE TABLE Audit_Log (
    log_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT,
    action VARCHAR(255),
    details TEXT,
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES User(user_id)
);

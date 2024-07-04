import pool from './database.js';

const createTables = async () => {
  const userTableQuery = `
    CREATE TABLE IF NOT EXISTS users (
      user_id INT AUTO_INCREMENT PRIMARY KEY,
      name VARCHAR(255) NOT NULL,
      email VARCHAR(255) NOT NULL,
      password VARCHAR(255) NOT NULL,
      phone VARCHAR(20),
      address VARCHAR(255),
      created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
      updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
      is_verified BOOLEAN,
      verification_type VARCHAR(50),
      video_verification_status VARCHAR(50),
      account_status VARCHAR(50)
    );
  `;

  const driverTableQuery = `
    CREATE TABLE IF NOT EXISTS drivers (
      driver_id INT AUTO_INCREMENT PRIMARY KEY,
      user_id INT,
      vehicle_details VARCHAR(255),
      license_number VARCHAR(50),
      insurance_details VARCHAR(255),
      driver_rating FLOAT,
      created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
      updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
      FOREIGN KEY (user_id) REFERENCES users(user_id)
    );
  `;

  const rideRequestTableQuery = `
    CREATE TABLE IF NOT EXISTS ride_requests (
      request_id INT AUTO_INCREMENT PRIMARY KEY,
      user_id INT,
      origin VARCHAR(255),
      destination VARCHAR(255),
      ride_time DATETIME,
      ride_type VARCHAR(50),
      status VARCHAR(50),
      created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
      updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
      FOREIGN KEY (user_id) REFERENCES users(user_id)
    );
  `;

  const rideTableQuery = `
    CREATE TABLE IF NOT EXISTS rides (
      ride_id INT AUTO_INCREMENT PRIMARY KEY,
      request_id INT,
      driver_id INT,
      ride_status VARCHAR(50),
      actual_start_time DATETIME,
      actual_end_time DATETIME,
      created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
      updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
      FOREIGN KEY (request_id) REFERENCES ride_requests(request_id),
      FOREIGN KEY (driver_id) REFERENCES drivers(driver_id)
    );
  `;

  const conversationTableQuery = `
    CREATE TABLE IF NOT EXISTS conversations (
      conversation_id INT AUTO_INCREMENT PRIMARY KEY,
      ride_id INT,
      created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
      FOREIGN KEY (ride_id) REFERENCES rides(ride_id)
    );
  `;

  const messageTableQuery = `
    CREATE TABLE IF NOT EXISTS messages (
      message_id INT AUTO_INCREMENT PRIMARY KEY,
      conversation_id INT,
      sender_id INT,
      receiver_id INT,
      message_text TEXT,
      sent_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
      FOREIGN KEY (conversation_id) REFERENCES conversations(conversation_id),
      FOREIGN KEY (sender_id) REFERENCES users(user_id),
      FOREIGN KEY (receiver_id) REFERENCES users(user_id)
    );
  `;

  const complaintTableQuery = `
    CREATE TABLE IF NOT EXISTS complaints (
      complaint_id INT AUTO_INCREMENT PRIMARY KEY,
      user_id INT,
      ride_id INT,
      complaint_text TEXT,
      status VARCHAR(50),
      created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
      updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
      FOREIGN KEY (user_id) REFERENCES users(user_id),
      FOREIGN KEY (ride_id) REFERENCES rides(ride_id)
    );
  `;

  const verificationTableQuery = `
    CREATE TABLE IF NOT EXISTS verifications (
      verification_id INT AUTO_INCREMENT PRIMARY KEY,
      user_id INT,
      document_type VARCHAR(50),
      document_number VARCHAR(50),
      document_image TEXT,
      verification_status VARCHAR(50),
      created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
      updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
      FOREIGN KEY (user_id) REFERENCES users(user_id)
    );
  `;

  const cancellationTableQuery = `
    CREATE TABLE IF NOT EXISTS cancellations (
      cancellation_id INT AUTO_INCREMENT PRIMARY KEY,
      user_id INT,
      ride_id INT,
      cancellation_time DATETIME,
      reason TEXT,
      FOREIGN KEY (user_id) REFERENCES users(user_id),
      FOREIGN KEY (ride_id) REFERENCES rides(ride_id)
    );
  `;

  const ratingTableQuery = `
    CREATE TABLE IF NOT EXISTS ratings (
      rating_id INT AUTO_INCREMENT PRIMARY KEY,
      ride_id INT,
      rater_id INT,
      ratee_id INT,
      rating FLOAT,
      review TEXT,
      created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
      FOREIGN KEY (ride_id) REFERENCES rides(ride_id),
      FOREIGN KEY (rater_id) REFERENCES users(user_id),
      FOREIGN KEY (ratee_id) REFERENCES users(user_id)
    );
  `;

  try {
    await pool.query(userTableQuery);
    await pool.query(driverTableQuery);
    await pool.query(rideRequestTableQuery);
    await pool.query(rideTableQuery);
    await pool.query(conversationTableQuery);
    await pool.query(messageTableQuery);
    await pool.query(complaintTableQuery);
    await pool.query(verificationTableQuery);
    await pool.query(cancellationTableQuery);
    await pool.query(ratingTableQuery);
    console.log('Tables created successfully');
  } catch (error) {
    console.error('Error creating tables:', error);
  } finally {
    pool.end();
  }
};

createTables();

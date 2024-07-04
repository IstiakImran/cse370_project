import { pool } from "../config/database.js";

export async function createUser(req, res) {
  const { name, email, password, phone, address, is_verified, verification_type, video_verification_status, account_status } = req.body;
  const query = `
    INSERT INTO users (name, email, password, phone, address, created_at, updated_at, is_verified, verification_type, video_verification_status, account_status)
    VALUES (?, ?, ?, ?, ?, NOW(), NOW(), ?, ?, ?, ?)
  `;

  try {
    const [result] = await pool.execute(query, [name, email, password, phone, address, is_verified, verification_type, video_verification_status, account_status]);
    res.status(201).json({ id: result.insertId });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
}

export async function getUsers(req, res) {
  const query = 'SELECT * FROM users';

  try {
    const [rows] = await pool.execute(query);
    res.status(200).json(rows);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
}

export async function getUser(req, res) {
    console.log(req)
  const query = 'SELECT * FROM users WHERE user_id = ?';

  try {
    const [rows] = await pool.execute(query, [req.params.id]);
    if (rows.length > 0) {
      res.status(200).json(rows[0]);
    } else {
      res.status(404).json({ message: 'User not found' });
    }
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
}

export async function updateUser(req, res) {
  const { name, email, password, phone, address, is_verified, verification_type, video_verification_status, account_status } = req.body;
  const query = `
    UPDATE users SET name = ?, email = ?, password = ?, phone = ?, address = ?, updated_at = NOW(), is_verified = ?, verification_type = ?, video_verification_status = ?, account_status = ?
    WHERE user_id = ?
  `;

  try {
    const [result] = await pool.execute(query, [name, email, password, phone, address, is_verified, verification_type, video_verification_status, account_status, req.params.id]);
    if (result.affectedRows > 0) {
      res.status(200).json({ message: 'User updated' });
    } else {
      res.status(404).json({ message: 'User not found' });
    }
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
}

export async function deleteUser(req, res) {
  const query = 'DELETE FROM users WHERE user_id = ?';

  try {
    const [result] = await pool.execute(query, [req.params.id]);
    if (result.affectedRows > 0) {
      res.status(204).json({ message: 'User deleted' });
    } else {
      res.status(404).json({ message: 'User not found' });
    }
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
}

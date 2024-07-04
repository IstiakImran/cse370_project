import { Router } from 'express';
const router = Router();
import { createUser, getUser, updateUser, deleteUser, getUsers } from '../controllers/userController.js';

router.get('/users', getUsers);
router.post('/users', createUser);
router.get('/users/:id', getUser);
router.put('/users/:id', updateUser);
router.delete('/users/:id', deleteUser);

export default router;

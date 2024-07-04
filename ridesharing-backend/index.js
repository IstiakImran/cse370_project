import express from 'express';
import bodyParser from 'body-parser';
import userRoutes from './src/routes/userRoutes.js';

const app = express();

app.use(bodyParser.json());

// Define API routes before the root URL route
app.use('/api', userRoutes);


app.use((err, req, res, next) => {
  res.status(500).json({ message: err.message });
});

const PORT = process.env.PORT || 5001;

app.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}`);
});

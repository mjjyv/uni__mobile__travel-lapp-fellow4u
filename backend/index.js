const express = require('express');
const cors = require('cors');
require('dotenv').config();
const { sequelize } = require('./src/models');

const app = express();
const PORT = process.env.PORT || 3000;

// Middleware
app.use(cors());
app.use(express.json());

// Routes
const authRoutes = require('./src/routes/authRoutes');
const exploreRoutes = require('./src/routes/exploreRoutes');

app.get('/', (req, res) => {
  res.json({ message: 'Welcome to Fellow4U API' });
});

app.use('/api/auth', authRoutes);
app.use('/api/explore', exploreRoutes);

// Database Connection & Server Start
const startServer = async () => {
  try {
    await sequelize.authenticate();
    console.log('✅ Connection to PostgreSQL has been established successfully.');
    
    // Sync models (Optional: be careful in production)
    // await sequelize.sync(); 

    app.listen(PORT, () => {
      console.log(`🚀 Server is running on http://localhost:${PORT}`);
    });
  } catch (error) {
    console.error('❌ Unable to connect to the database:', error);
  }
};

startServer();

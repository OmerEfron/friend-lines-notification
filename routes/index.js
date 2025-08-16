const express = require('express');
const router = express.Router();
const notificationRoutes = require('./notificationRoutes');

// Register all route modules
router.use('/notification', notificationRoutes);

module.exports = router;

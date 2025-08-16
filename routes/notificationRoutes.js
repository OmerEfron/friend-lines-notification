const express = require('express');
const router = express.Router();
const { createNotification } = require('../controllers/notificationController');

// Notification routes
router.post('/create-new-notification', createNotification);

module.exports = router;

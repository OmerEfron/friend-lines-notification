/**
 * Notification Controller
 * Handles notification-related business logic
 */

/**
 * Create a new notification
 * @param {Object} req - Express request object
 * @param {Object} res - Express response object
 * @param {Function} next - Express next function
 */
const createNotification = async (req, res, next) => {
  try {
    const { content } = req.body;
    
    // Validate content
    if (!content || typeof content !== 'string') {
      return res.status(400).json({
        error: 'Bad Request',
        message: 'Content is required and must be a string'
      });
    }
    
    // Process notification (business logic can be added here)
    const notificationMessage = `new content received: ${content}`;
    
    res.status(200).json({
      message: notificationMessage,
      timestamp: new Date().toISOString()
    });
  } catch (error) {
    next(error);
  }
};

module.exports = {
  createNotification
};

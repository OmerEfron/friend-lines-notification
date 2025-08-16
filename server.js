const express = require('express');

// Import routes
const routes = require('./routes');

// Create Express app
const app = express();
const PORT = process.env.PORT || 3005;

// Middleware order: body parsers, custom middleware, routes, error handlers
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

// Custom middleware for logging
app.use((req, res, next) => {
  console.log(`${new Date().toISOString()} - ${req.method} ${req.path}`);
  next();
});

// Health endpoint
app.get('/health', (req, res) => {
  res.status(200).json({
    status: 'OK',
    timestamp: new Date().toISOString(),
    uptime: process.uptime(),
    environment: process.env.NODE_ENV || 'development'
  });
});

// Root endpoint
app.get('/', (req, res) => {
  res.status(200).json({
    message: 'Friend Lines App Server',
    version: '1.0.0',
    endpoints: {
      health: '/health',
      root: '/',
      notification: '/notification/create-new-notification'
    }
  });
});

// Register all routes
app.use('/', routes);

// 404 handler for undefined routes
app.use('*', (req, res) => {
  res.status(404).json({
    error: 'Route not found',
    path: req.originalUrl
  });
});

// Centralized error handler middleware (last middleware)
app.use((err, req, res, next) => {
  console.error('Error:', err);
  res.status(err.status || 500).json({
    error: 'Internal server error',
    message: process.env.NODE_ENV === 'development' ? err.message : 'Something went wrong'
  });
});

// Start server
app.listen(PORT, () => {
  console.log(`🚀 Server running on port ${PORT}`);
  console.log(`📍 Health check: http://localhost:${PORT}/health`);
  console.log(`🌐 Server: http://localhost:${PORT}`);
});

module.exports = app;

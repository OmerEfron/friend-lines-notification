# Friend Lines App Server

A simple Express.js server with a health endpoint, following Express.js best practices.

## Features

- ✅ Express.js server with proper middleware order
- ✅ Health endpoint for monitoring
- ✅ Notification creation endpoint
- ✅ Modular route structure with controllers
- ✅ Request logging middleware
- ✅ Centralized error handling
- ✅ 404 route handling
- ✅ Environment-based configuration

## Installation

```bash
npm install
```

## Usage

### Start the server
```bash
npm start
```

### Development mode (with auto-restart)
```bash
npm run dev
```

## Endpoints

### Health Check
- **GET** `/health` - Server health status
- Returns server status, timestamp, uptime, and environment

### Root
- **GET** `/` - Server information
- Returns server details and available endpoints

### Notification
- **POST** `/notification/create-new-notification` - Create a new notification
- **Body**: `{"content": "string"}`
- **Returns**: `{"message": "new content received: <content>", "timestamp": "..."}`

## Configuration

- **Port**: 3005 (configurable via `PORT` environment variable)
- **Environment**: Development (configurable via `NODE_ENV`)

## Server Details

- **Port**: 3005
- **Health Check**: http://localhost:3005/health
- **Server**: http://localhost:3005

## Project Structure

```
friend-lines-app/
├── server.js                    # Main server file
├── package.json                 # Dependencies and scripts
├── routes/                      # Route modules
│   ├── index.js                # Routes registry
│   └── notificationRoutes.js   # Notification routes
├── controllers/                 # Business logic controllers
│   └── notificationController.js # Notification controller
└── README.md                   # This file
```

## Express.js Best Practices Implemented

- Proper middleware order (body parsers → custom middleware → routes → error handlers)
- Centralized error handling middleware
- Request logging
- Appropriate HTTP status codes
- Environment-based error messages
- Modular route structure with Express Router
- Separation of concerns (routes, controllers, business logic)
- Input validation for notification content

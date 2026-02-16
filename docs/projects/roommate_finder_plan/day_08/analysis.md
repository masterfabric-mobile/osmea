# Day 08: Messaging & Chat Logic

## Objectives
- Define `ChatMessage` and `ChatSession` models.
- Implement `ChatService` with mock data for real-time simulation.
- Set up `ChatViewModel` to handle sending and receiving messages.

## Required API Endpoints
- `GET /conversations`: Retrieve list of active conversations.
- `POST /conversations`: Start a new conversation (or get existing ID).
- `GET /conversations/{id}/messages`: Fetch chat history.
- `POST /conversations/{id}/messages`: Send a new message.
- `PUT /conversations/{id}/read`: Mark messages as read.

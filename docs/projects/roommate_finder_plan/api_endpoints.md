# Roommate Finder App - API Endpoints & Data Structure

This document outlines the API endpoints required for the Roommate Finder application. The API follows RESTful principles.

## Base URL
`https://api.roommatefinder.com/v1` (Mock for development)

## 1. Authentication (Auth)
Handles user registration, login, and session management.

| Method | Endpoint | Description | Request Body | Response |
| :--- | :--- | :--- | :--- | :--- |
| `POST` | `/auth/register` | Register a new user | `{ "email": "...", "password": "...", "full_name": "..." }` | `{ "token": "...", "user": { ... } }` |
| `POST` | `/auth/login` | Login existing user | `{ "email": "...", "password": "..." }` | `{ "token": "...", "user": { ... } }` |
| `POST` | `/auth/refresh-token` | Refresh access token | `{ "refresh_token": "..." }` | `{ "token": "..." }` |
| `POST` | `/auth/logout` | Logout user | - | `{ "message": "Logged out" }` |
| `POST` | `/auth/forgot-password` | Request password reset | `{ "email": "..." }` | `{ "message": "Email sent" }` |

## 2. User Profile (Users)
Manages user details, preferences, and lifestyle choices.

| Method | Endpoint | Description | Request Body | Response |
| :--- | :--- | :--- | :--- | :--- |
| `GET` | `/users/me` | Get current user profile | - | `{ "id": "...", "preferences": { ... } }` |
| `PUT` | `/users/me` | Update profile & preferences | `{ "bio": "...", "preferences": { "smoking": false, ... } }` | `{ "user": { ... } }` |
| `POST` | `/users/me/avatar` | Upload profile picture | `Multipart File` | `{ "avatar_url": "..." }` |
| `GET` | `/users/{id}` | Get public profile of another user | - | `{ "id": "...", "public_info": { ... } }` |

## 3. Listings (Rooms)
CRUD operations for room listings.

| Method | Endpoint | Description | Request Body | Response |
| :--- | :--- | :--- | :--- | :--- |
| `GET` | `/listings` | Search & Filter listings | `?min_price=...&max_price=...&city=...` | `[ { "id": "...", "title": "..." }, ... ]` |
| `POST` | `/listings` | Create a new room listing | `{ "title": "...", "price": 1000, "location": { ... } }` | `{ "id": "...", "listing": { ... } }` |
| `GET` | `/listings/{id}` | Get listing details | - | `{ "id": "...", "images": [...], "owner": { ... } }` |
| `PUT` | `/listings/{id}` | Update listing | `{ "price": 1200, ... }` | `{ "listing": { ... } }` |
| `DELETE`| `/listings/{id}` | Delete listing | - | `{ "success": true }` |
| `POST` | `/listings/{id}/images`| Upload listing photos | `Multipart Files` | `{ "image_urls": [...] }` |

## 4. Matching & Recommendations
Core logic for finding roommates.

| Method | Endpoint | Description | Request Body | Response |
| :--- | :--- | :--- | :--- | :--- |
| `GET` | `/matches/recommendations` | Get suggested users/listings | `?limit=10&offset=0` | `[ { "type": "user|room", "score": 95, "data": { ... } } ]` |
| `POST` | `/matches/swipe` | Like or Pass a recommendation | `{ "target_id": "...", "action": "like|pass" }` | `{ "match": true|false }` (Returns true if it's a match) |
| `GET` | `/matches` | Get list of mutual matches | - | `[ { "match_id": "...", "user": { ... } } ]` |

## 5. Chat & Messaging
Real-time communication between matched users.

| Method | Endpoint | Description | Request Body | Response |
| :--- | :--- | :--- | :--- | :--- |
| `GET` | `/conversations` | Get all active chats | - | `[ { "id": "...", "last_message": "...", "unread_count": 2 } ]` |
| `POST` | `/conversations` | Start a new conversation | `{ "recipient_id": "..." }` | `{ "conversation_id": "..." }` |
| `GET` | `/conversations/{id}/messages` | Get message history | `?limit=50&before=timestamp` | `[ { "id": "...", "text": "...", "sender_id": "..." } ]` |
| `POST` | `/conversations/{id}/messages` | Send a message | `{ "text": "...", "type": "text|image" }` | `{ "id": "...", "timestamp": "..." }` |

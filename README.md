# Go Todo Application with Glassmorphism UI ✅

A modern, full-stack **Todo Application** built with **Go (Backend)**, **Vue.js (Frontend)**, and **MongoDB (Database)**.  
It features a beautiful **Glassmorphism UI**, full CRUD functionality, and a responsive design.

---

## 📋 Project Overview

- **Project Name:** Go Todo Application  
- **Tech Stack:** Go, Vue.js, MongoDB  
- **Development Period:** September 2024  
- **Status:** ✅ Complete & Functional  

---

## 🏗️ Architecture

                          ┌───────────────────────────┐
                          │        Frontend UI        │
                          │  Vue.js + Bootstrap + CSS │
                          │  - Glassmorphism Design   │
                          │  - Responsive Layout      │
                          └───────────▲──────────────┘
                                      │
                         (HTTP / JSON API Calls)
                                      │
                          ┌───────────┴──────────────┐
                          │        Go Backend        │
                          │    (Chi Router v5)       │
                          │                         │
       ┌───────────────┐  │   ┌──────────────────┐   │
       │   Middleware  │◄─┼──►│  REST Handlers   │   │
       │ - Logging     │  │   │ - CRUD for Todos │   │
       │ - Recovery    │  │   │ - JSON Renderer  │   │
       │ - Timeout     │  │   │ - Error Handler  │   │
       └───────────────┘  │   └──────────────────┘   │
                          │                         │
                          │   ┌──────────────────┐   │
                          │   │ Renderer Engine  │   │
                          │   │ - HTML Templates │   │
                          │   │ - JSON Responses │   │
                          │   └──────────────────┘   │
                          └───────────┬──────────────┘
                                      │
                                (Mongo Driver)
                                      │
                          ┌───────────┴──────────────┐
                          │       MongoDB            │
                          │ - Collection: todo       │
                          │ - Stores Todos:          │
                          │   {id, title, completed} │
                          └──────────────────────────┘



---

## 🔧 Features

### Backend (Go)
- REST API with **Chi Router**
- MongoDB CRUD operations  
- Centralized error handling  
- Graceful shutdown & context handling  

### Frontend (Vue.js)
- Responsive glassmorphism UI  
- Real-time CRUD operations  
- Form validation & confirmation dialogs  
- Smooth transitions & hover effects  

### Database (MongoDB)
- NoSQL schema for todos  
- ObjectID-based unique identifiers  
- Collection: `todo`  

---

## 📁 Project Structure

```bash

go-todo/
├── .gitignore
├── go.mod
├── go.sum
├── main.go
├── static/
│   └── home.tpl
└── PROJECT_REPORT.md
🛠️ Setup & Installation
Prerequisites

Go 1.23.4+

MongoDB Community Edition

Node.js (for Vue.js if extended)

Run Locally
# Clone repo
git clone https://github.com/<your-username>/go-todo.git
cd go-todo

# Install Go dependencies
go mod tidy

# Start MongoDB (Mac example)
brew services start mongodb-community

# Run backend server
go run main.go


Server runs on http://localhost:9000

MongoDB on localhost:27017
```

**Author:** [Anil Rajput](https://www.linkedin.com/in/anil-behera-4a9597293/)


Status: ✅ Complete

Generated On: September 19, 2024


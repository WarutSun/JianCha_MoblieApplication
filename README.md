# JianCha_MoblieApplication

> **Phase:** 2 — Maintenance & New Features

---

## Live Demo

| Platform | URL |
|----------|-----|
| Web Application | [https://jianchatravelnaja.vercel.app/](https://jianchatravelnaja.vercel.app/) |
| Mobile App | See [Mobile App Setup](#-mobile-app-setup) below |

---

## System Architecture

```
┌─────────────────────┐     ┌─────────────────────┐
│   Web Frontend      │     │   Android Mobile    │
│  React + Vite +     │     │   Native App        │
│  Tailwind + shadcn  │     │   (Kotlin/Java)     │
└────────┬────────────┘     └──────────┬──────────┘
         │                             │
         └──────────┬──────────────────┘
                    ▼
         ┌─────────────────────┐
         │   Backend API       │
         │  Node.js + Express  │
         │  JWT Authentication │
         └────────┬────────────┘
                  ▼
         ┌─────────────────────┐
         │   MySQL Database    │
         │   (Docker)          │
         └─────────────────────┘
```

| Layer | Technology |
|-------|-----------|
| Frontend | React, Vite, Tailwind CSS, shadcn/ui |
| Backend | Node.js, Express, JWT |
| Database | MySQL (via Docker) |
| Mobile | Native Android (Kotlin/Java) |
| Deployment (Frontend) | Vercel |
| Deployment (Backend) | Render |

---

## Mobile Application

> **Added in Phase 2**

A native Android mobile application was developed in Phase 2 to extend TravelNaja's reach to mobile users. The app supports **all user-facing functionalities** available on the web system, including:

- Browse and search available cars
- Make and manage reservations
- View rental history
- Submit car reviews (new Phase 2 feature)
- One-way rental booking (new Phase 2 feature)

**Mobile Repository:** [INSERT MOBILE REPO LINK HERE](https://github.com/WarutSun/JianCha_MoblieApplication)

---

## New Features (Phase 2 Maintenance)
---
### Feature 1 —  Car Review System
Users who have **completed and returned a rental** can leave feedback on the car and the rental company.

**Functionality:**
- Rate the car from **1 to 5 stars**
- Write a text review about condition, cleanliness, and service quality
- Reviews are displayed publicly to help other users make informed decisions

---
### Feature 2 — One-Way Rental / Different Drop-off Location
Users can now choose **different pick-up and drop-off locations** in a single booking.

**Functionality:**
- Select pick-up location (e.g., Chiang Mai Airport)
- Select a different drop-off location (e.g., downtown Chiang Rai)
- System **automatically calculates** the additional one-way drop-off fee

---

## Tech Stack

| Category | Technologies |
|----------|-------------|
| **Frontend** | React, Vite, Tailwind CSS, shadcn/ui |
| **Backend** | Node.js, Express |
| **Database** | MySQL |
| **Mobile** | Android — Kotlin / Java |
| **DevOps** | Docker, GitHub Actions, SonarQube |

---

## Installation & Setup

### Prerequisites
- Node.js v18+
- Docker & Docker Compose
- Git

### 1. Clone the Repository

```bash
# Web / Backend repository
git clone https://github.com/WarutSun/2025-ITCS383-JianCha
cd 2025-ITCS383-JianCha
```

### 2. Start the Database (Docker)

```bash
docker-compose up -d
```

> This spins up a MySQL instance. Wait a few seconds for it to initialize.

### 3. Run the Backend

```bash
cd backend
npm install
npm run dev
```

The backend runs on `http://localhost:5000` by default.

### 4. Run the Frontend

```bash
cd frontend
npm install
npm run dev
```

The web app runs on `http://localhost:5173` by default.

---

## Mobile App Setup


### Steps

1. **Clone the mobile repository:**
   ```bash
   git clone https://github.com/WarutSun/JianCha_MoblieApplication
   ```

2. **Open in Android Studio:**
   - Launch Android Studio
   - Select **Open** → Navigate to the cloned project folder

3. **Configure the API Base URL:**
   - Open `app/src/main/java/.../network/ApiConfig.kt` (or equivalent config file)
   - Update `BASE_URL` to point to your backend:
     ```kotlin
     const val BASE_URL = "https://your-backend-url.onrender.com/api/"
     ```
   - If running locally, use your machine's IP (not `localhost`):
     ```kotlin
     const val BASE_URL = "http://192.168.x.x:5000/api/"
     ```

4. **Run the App:**
   - Connect a physical Android device (USB debugging enabled), **or** start an Android Emulator (API level 26+)
   - Click the **▶ Run** button in Android Studio
   - Select your device/emulator and wait for the app to build and launch

---

## 🔌 API Overview

| Category | Endpoint | Description |
|----------|----------|-------------|
| **Auth** | `POST /api/auth/register` | Register a new member |
| **Auth** | `POST /api/auth/login` | Login and receive JWT token |
| **Cars** | `GET /api/cars` | List all available cars |
| **Cars** | `GET /api/cars/:id` | Get car details |
| **Cars** | `GET /api/cars/:id/reviews` | Get reviews for a car |
| **Bookings** | `POST /api/bookings` | Create a new booking |
| **Bookings** | `GET /api/bookings/my` | Get user's booking history |
| **Bookings** | `POST /api/bookings/:id/review` | Submit a review after return |
| **Staff** | `GET /api/staff/bookings` | View all bookings (staff only) |
| **Staff** | `PATCH /api/staff/bookings/:id` | Update booking status (staff only) |

> All protected endpoints require `Authorization: Bearer <token>` in the request header.

---

## 🔄 CI/CD Pipeline

The project uses **GitHub Actions** for continuous integration and deployment.

```
Push to main branch
       │
       ▼
┌──────────────────┐
│  GitHub Actions  │
│  - Install deps  │
│  - Run tests     │
│  - Build project │
└────────┬─────────┘
         │
         ▼
┌──────────────────┐
│   SonarQube      │
│  Code Quality    │
│  Analysis        │
└────────┬─────────┘
         │
         ▼
┌──────────────────┐
│   Deploy         │
│  Vercel (web)    │
│  Render (api)    │
└──────────────────┘
```

- **GitHub Actions** — Automates build, test, and deployment on every push
- **SonarQube** — Scans for bugs, code smells, vulnerabilities, and duplication

---

## 🧪 Testing

- **Automated unit and integration tests** are included for both backend and new features
- **Coverage requirement:** New code must achieve **>90% test coverage**
- Run tests locally:

```bash
# Backend tests
cd backend
npm run test

# Frontend tests
cd frontend
npm run test
```

---

## 📁 Project Structure

```
2025-ITCS383-JianCha/
├── frontend/                  # React web application
│   ├── src/
│   │   ├── components/        # Reusable UI components
│   │   ├── pages/             # Page-level components
│   │   ├── hooks/             # Custom React hooks
│   │   └── lib/               # Utility functions
│   └── vite.config.js
│
├── backend/                   # Node.js + Express API
│   ├── src/
│   │   ├── controllers/       # Route controllers
│   │   ├── models/            # Database models
│   │   ├── routes/            # API route definitions
│   │   ├── middleware/        # Auth & error middleware
│   │   └── tests/             # Automated tests
│   └── server.js
│
├── docker-compose.yml         # MySQL database setup
├── .github/
│   └── workflows/             # GitHub Actions CI/CD
│
└── docs/                      # Project documentation
    ├── D2_CODE_QUALITY.md
    ├── D3_CHANGE_REQUESTS.md
    ├── D4_IMPACT_ANALYSIS.md
    └── D5_AI-USAGE.md
```
## 👥 Team Members

| Student ID | Name |
|------------|------|
| 6688046 |  Warut    Khamkaveephart |
| 6688194  | Muhummadcharif    Kapa |
| 6688083  |Teeramanop    Pinsupa |
| 6688148 |  Bunyakorn    Wongchadakul |
| 6688205  | Sirawit    Noomanoch |
| 6688226  |  Thanawat    Thanasirithip |

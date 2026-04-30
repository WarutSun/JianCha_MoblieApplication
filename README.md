# JianCha Mobile Application

> **Platform:** Native Android  
> **Phase:** 2 — Maintenance & New Features

---

## Mobile Repository

**[https://github.com/WarutSun/JianCha_MoblieApplication](https://github.com/WarutSun/JianCha_MoblieApplication)**

---

## About

A native Android mobile application developed in Phase 2 to extend TravelNaja's reach to mobile users. The app supports all user-facing functionalities of the car rental system, including two new Phase 2 features.

---

## New Features (Phase 2)

### Feature 1 — Car Review System

Users who have **completed and returned a rental** can leave feedback on the car.

- Rate the car from **1 to 5 stars**
- Write a text review (up to 500 characters)
- Reviews are displayed publicly to help other users make informed decisions

### Feature 2 — One-Way Rental / Different Drop-off Location

Users can now choose **different pick-up and drop-off locations** in a single booking.

- Select a pick-up location (e.g., Chiang Mai Airport)
- Select a different drop-off location (e.g., downtown Chiang Rai)
- System **automatically calculates** the additional one-way drop-off fee (500 THB)

---

## Tech Stack

| Category | Technology |
|----------|-----------|
| Mobile Platform | Native Android |
| Language | Kotlin / Java |
| Backend API | Node.js + Express (hosted on Render) |
| Database | MySQL (hosted on Clever Cloud) |
| CI/CD | GitHub Actions |
| Code Quality | SonarQube |

---

## Mobile App Setup

### Prerequisites

- Android Studio (latest stable version)
- Android Emulator (API level 26+) or a physical Android device with USB debugging enabled
- Backend API running (locally or on Render)

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
   - If running the backend locally, use your machine's LAN IP (not `localhost`):
     ```kotlin
     const val BASE_URL = "http://192.168.x.x:8080/api/"
     ```

4. **Run the App:**
   - Connect a physical Android device (USB debugging enabled), **or** start an Android Emulator (API level 26+)
   - Click the **▶ Run** button in Android Studio
   - Select your device/emulator and wait for the app to build and launch

---

## API Endpoints Used by Mobile App

| Category | Method | Endpoint | Description |
|----------|--------|----------|-------------|
| **Auth** | POST | `/api/auth/register` | Register a new member |
| **Auth** | POST | `/api/auth/login` | Login and receive JWT token |
| **Cars** | GET | `/api/cars` | List all available cars |
| **Cars** | GET | `/api/cars/:id` | Get car details |
| **Reviews** | GET | `/api/reviews/car/:carId` | Get reviews for a car |
| **Bookings** | POST | `/api/bookings` | Create a new booking (supports drop-off location) |
| **Bookings** | GET | `/api/bookings` | Get user's booking history |
| **Bookings** | PUT | `/api/bookings/:id/pay` | Confirm payment for a booking |
| **Bookings** | PUT | `/api/bookings/:id/return` | Return car and complete booking |
| **Reviews** | POST | `/api/reviews` | Submit a review after return |

> All protected endpoints require `Authorization: Bearer <token>` in the request header.

---

## CI/CD Pipeline

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
└──────────────────┘
```

- **GitHub Actions** — Automates build, test, and deployment on every push
- **SonarQube** — Scans for bugs, code smells, vulnerabilities, and duplication

---

## Project Structure

```
JianCha_MoblieApplication/
├── app/
│   └── src/
│       └── main/
│           ├── java/
│           │   └── .../
│           │       ├── network/       # API config & Retrofit setup
│           │       ├── ui/            # Activities & Fragments
│           │       ├── viewmodel/     # ViewModels
│           │       └── model/         # Data models
│           └── res/                   # Layouts, drawables, strings
├── .github/
│   └── workflows/                     # GitHub Actions CI/CD
└── build.gradle
```

---

## 👥 Team Members

| Student ID | Name |
|------------|------|
| 6688046 | Warut Khamkaveephart |
| 6688194 | Muhummadcharif Kapa |
| 6688083 | Teeramanop Pinsupa |
| 6688148 | Bunyakorn Wongchadakul |
| 6688205 | Sirawit Noomanoch |
| 6688226 | Thanawat Thanasirithip |

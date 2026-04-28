---

[]---Use this in project---[]
the old one

 # Impact Analysis: Requirements → Design → Code → Test


 
![Context Diagram](https://github.com/WarutSun/JianCha_MoblieApplication/blob/d603628a4cffc5a8ee57ccec0116d29e5c65f23f/Brfore_chages.drawio.svg)
---

## Impact Matrix: Change in Requirement

| Changed Requirement | Affected Container | Affected Code Component | Affected Data Op | Affected Test |
|---------------------|--------------------|--------------------------|------------------|----------------|
| **R1: Guest register** | Auth Service, Database | AuthController.register(), UserService.create(), UserRepository.save() | D4 Write | Registration unit tests, duplicate user test, hash verification test |
| **R2: Guest view promotion** | Promotion Service, API Gateway | PromotionController.getPublic(), CacheMiddleware | D1 Call + D3 Query | Public access test, cache hit/miss test, empty list test |
| **R3: Member view promotion** | Promotion Service, Auth Service | PromotionController.getMember(), AuthMiddleware.verifyJWT() | D1 Call + D3 Query | Auth token test, role-based access test |
| **R4: Login** | Auth Service | AuthController.login(), AuthService.generateJWT(), PasswordValidator | D4 Read | Valid/invalid password test, JWT expiry test |
| **R5: Update profile** | Auth Service, Database | ProfileController.update(), ProfileService.validate(), UserRepository.update() | D4 Write | Profile update test, validation failure test |
| **R6: Member register** | Auth Service | UserController.registerMember(), RoleAssigner | D4 Write | Role assignment test, duplicate email test |
| **R7: Track reservation** | Reservation Service | ReservationController.track(), ForwardRequestService | D2 Forward + D3 Query | Service forwarding test, invalid ID test, timeout test |
| **R8: Generate report** | Report Generator | ReportController.generate(), QueryAggregator, FileExporter | D3 Query + D4 Read | Date range test, performance test, file format test |

---

## Impact by Data Operation Change

| Changed Data Op | Impact on Requirements | Impact on Design | Impact on Code | Impact on Test |
|----------------|------------------------|------------------|----------------|----------------|
| **D1: API call** | All R1–R8 | API Gateway routes, rate limiting | Controllers, route handlers, middleware | API endpoint tests, status code tests |
| **D2: Forward request** | R7 only | Reservation Service, Service Discovery | HTTP client, retry logic, circuit breaker | Service mock tests, fallback tests |
| **D3: Query data** | R2, R3, R7, R8 | Promotion/Reservation/Report containers | Query builder, repository layer, index usage | Query performance tests, result accuracy |
| **D4: Read/Write** | R1, R4, R5, R6 | Database schema, transaction boundaries | Repository save/find/update, migration scripts | ACID tests, concurrent write tests, rollback tests |

---


![Context Diagram](https://github.com/WarutSun/JianCha_MoblieApplication/blob/3f7bb08efbbbda996bcb64afa2dded314b7ebf87/After_chages.drawio.svg)


# Impact Analysis: Two New Features

 



## 1. New Requirements

| New Req ID | Description |  
|------------|-------------| 
| **F1** | Customer can rate and review a car after rental |
| **F2** | Customer can drop off the car at a different location (one-way rental)

---

## 2. New / Modified Design (D1–D4)

| Design Op | New/Modified | Purpose | Related Req |
|-----------|--------------|---------|-------------|
| **D5** (New) | Store review & rating | Write reviews to new `reviews` table | R9 |
| **D6** (New) | Fetch aggregated rating | Calculate average rating per car | R10 |
| **D7** (New) | Validate drop-off location | Check if location is valid and available | R11 |
| **D8** (New) | Calculate one-way fee | Price difference based on distance/location | R12 |
| D1 (Modified) | New API endpoints | `/api/reviews` (POST/GET), `/api/rentals/oneway` | R9,R10,R11,R12 |
| D3 (Modified) | Query reviews + locations | Join queries for ratings and location availability | R10,R11 |
| D4 (Modified) | Write one-way rental | Update rentals table with dropoff_location_id | R12 |

---

## 3. New / Modified Code Components (C1–C9 → Extended)

| Code Component | New/Modified | Responsibility | Related Req |
|----------------|--------------|----------------|-------------|
| **C10** (New) | `ReviewController` | Handle POST /reviews and GET /reviews/:carId | R9, R10 |
| **C11** (New) | `ReviewService` | Business logic: validate rating, prevent duplicate reviews | R9 |
| **C12** (New) | `RatingAggregator` | Calculate average rating per car | R10 |
| **C13** (New) | `LocationController` | Validate drop-off location availability | R11 |
| **C14** (New) | `OneWayCalculator` | Compute price difference for one-way rental | R12 |
| **C15** (New) | `ReviewRepository` | DB operations for reviews table | R9, R10 |
| C1 (Modified) | `RentalController` | Add drop location and one-way flag | R11, R12 |
| C4 (Modified) | `RentalRepository` | Update bookings to support one-way | R12 |
| C9 (Modified) | `ValidationMiddleware` | Add review validation (rating 1–5, no profanity) | R9 |
| C2 (Modified) | `AuthMiddleware` | Ensure only past renters can review | R9 |

---
this one we don't want


## 4. New / Modified Tests (T1–T8 → Extended)

| Test Component | New/Modified | Test Scenario | Related Req |
|----------------|--------------|---------------|-------------|
| **T9** (New) | `ReviewSubmissionTest` | Valid review returns 201, duplicate review returns 409 | R9 |
| **T10** (New) | `RatingCalculationTest` | Average rating calculates correctly | R10 |
| **T11** (New) | `ViewReviewsTest` | GET /reviews/:carId returns list with ratings | R10 |
| **T12** (New) | `OneWayLocationTest` | Valid drop-off location accepted, invalid rejected | R11 |
| **T13** (New) | `OneWayPriceTest` | Price difference calculated correctly | R12 |
| **T14** (New) | `ReviewAuthTest` | Only past renters can post review, others get 403 | R9 |
| T1 (Modified) | `RegistrationTest` | No change (unaffected) | — |
| T4 (Modified) | `LoginTest` | No change (unaffected) | — |
| T7 (Modified) | `ReservationTest` | Add one-way rental test cases | R11,R12 |

Im thinking this part 4 should I take or not ?

---
 

## 5. Updated Traceability Matrix

| Requirement | Design (Data Op) | Code Component | Test |
|-------------|------------------|----------------|------|
| R9 (Submit review) | D5 (Write review) | C10, C11, C15, C2 | T9, T14 |
| R10 (View reviews) | D6 (Fetch rating) | C10, C12, C15 | T10, T11 |
| R11 (One-way drop-off) | D7 (Validate location) | C13, C1 | T12 |
| R12 (One-way price) | D8 (Calculate fee) | C14, C4 | T13 |

---

## 6. Impact Summary Table

| Area | Existing | New Added | Modified | Total After |
|------|----------|-----------|----------|-------------|
| Requirements (R) | R1–R8 (8) | R9–R12 (4) | 0 | **12** |
| Design (D) | D1–D4 (4) | D5–D8 (4) | D1, D3, D4 (3) | **8** |
| Code (C) | C1–C9 (9) | C10–C15 (6) | C1, C2, C4, C9 (4) | **15** |
| Test (T) | T1–T8 (8) | T9–T14 (6) | T1, T4, T7 (3) | **14** |

---

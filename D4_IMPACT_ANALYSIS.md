---

[]---Use this in project---[]
the old one

 # Impact Analysis: Requirements → Design → Code → Test
 ## Not add any feature yet

 
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
# Impact Analysis: Two New Features

![Context Diagram](https://github.com/WarutSun/JianCha_MoblieApplication/blob/c5eac323032364a8653ca624ed127962a1e260a3/_the%20traceability%20graph.drawio.svg)
 
# Car Review System - Workflow Description

## Workflow Overview

This task follows a **linear but iterative workflow** from requirements to testing, ensuring each requirement is implemented in design, coded, and finally tested.

---

## Step 1: Requirement Analysis (R)

Each requirement defines a feature or system behavior:

| ID | Type | Description |
|----|------|-------------|
| R1 | Corrective | Car review system (fix errors in reviews) |
| R2 | Corrective | Car review system (fix errors in reviews) |
| R3 | Adaptive | Car review system (adapt to environment changes) |
| R4 | Adaptive | Car review system (adapt to environment changes) |
| R5 | Perfective | Car review system (improve performance) |
| R6 | Preventive | Car review system (prevent future issues) |
| R7 | Corrective | Car review system (fix errors in reviews) |
| R8 | Corrective | Car review system (fix errors in reviews) |
| R9 | Adaptive | Car review system (adapt to environment changes) |
| R10 | Perfective | Car review system (improve performance) |
| R11 | Preventive | Car review system (prevent future issues) |

---

## Step 2: Design Mapping (D)

Each design component supports one or more requirements:

| Design | Description | Related Requirements |
|--------|-------------|----------------------|
| D1 | Auth flow | All (base requirement) |
| D2 | Car listing | R3, R4, R9 |
| D3 | Booking form | R1, R2, R7 |
| D4 | Payment | R5, R10 |
| D5 | My bookings | R1, R2, R8 |
| D6 | Promo login | R6, R11 |
| D7 | Profile edit | R4, R9 |
| D8 | Dropoff fee | R5, R10 |

---

## Step 3: Coding Implementation (C)

Each code component implements a design:

| Code | Description | Implements Design |
|------|-------------|-------------------|
| C1 | LoginScreen | D1 |
| C2 | RegisterScreen | D1 |
| C3 | CarsScreen | D2 |
| C4 | BookingForm | D3 |
| C5 | PaymentSim | D4 |
| C6 | MyBookings | D5 |
| C7 | ProfileScreen | D7 |
| C8 | MainNav | D1–D8 (navigation) |

---

## Step 4: Testing (T)

Each test case verifies a code component and its requirement:

| Test | Description | Tests Code | Validates Requirement |
|------|-------------|------------|------------------------|
| T1 | Auth flow test | C1, C2, C8 | R6, R11 |
| T2 | Car listing test | C3 | R3, R4, R9 |
| T3 | Booking form test | C4 | R1, R2, R7 |
| T4 | Payment test | C5 | R5, R10 |
| T5 | My bookings test | C6 | R1, R2, R8 |
| T6 | Promo login test | C1, C8 | R6, R11 |
| T7 | Profile edit test | C7 | R4, R9 |
| T8 | Dropoff fee test | C4, C5 | R5, R10 |

---

## Visual Workflow Diagram

```text
R1–R11 (Requirements)
   ↓
D1–D8 (Designs)
   ↓
C1–C8 (Code Components)
   ↓
T1–T8 (Test Cases)
 
```
---
# 📊 Directed Graph of SLOs
 
---

## 🖼️ Diagram Reference
 
![Context Diagram](https://github.com/WarutSun/JianCha_MoblieApplication/blob/ddbb4c3fa79300544415d5a7d7e38c878b8a3c88/_Directed%20graph%20of%20SLOs.drawio.svg)


---
## 🖼️ Connectivity Matrix With Distances
 
| From \ To    | Auth flow | LoginScreen | RegisterScr | CarsScreen | Car listing | BookingFor | PaymentSim | MyBookings | ProfileScr | MainNav | Profile edit |
|--------------|----------|-------------|-------------|------------|-------------|------------|------------|------------|------------|---------|--------------|
| Auth flow    |          | 1           | 1           |            |             |            |            |            | 1          |         | 1            |
| LoginScreen  |          |             |             |            |             |            |            |            |            |         |              |
| RegisterScr  |          |             |             |            |             |            |            |            |            |         |              |
| CarsScreen   |          |             |             |            |             | 1          |            |            |            |         |              |
| Car listing  |          |             |             | 1          |             |            | 1          |            |            |         |              |
| BookingFor   |          |             |             |            |             |            |            | 1          |            |         |              |
| PaymentSim   |          |             |             |            |             |            |            |            |            |         |              |
| MyBookings   |          |             |             |            |             |            |            |            |            |         |              |
| ProfileScr   |          |             |             |            |             |            |            |            |            |         |              |
| MainNav      |          | 1           | 1           | 1          |             | 1          | 1          | 1          | 1          |         |              |
| Profile edit |          |             |             |            |             |            |            |            |            |         |              |


---



## 1. Easy Change Requests

| # | Change Request | Why It's Easy |
|---|---------------|---------------|
| 1 | **UI text & button labels** (e.g. "Book Now", "Proceed to Payment") | All strings are hardcoded inline — a simple find-and-replace is sufficient |
| 2 | **Color adjustments** (e.g. button color, status badge color) | Colors use consistent hex values like `Color(0xFF22C55E)` that are easy to locate across files |
| 3 | **Adding a new promo code** | Only requires appending a string to the `_validPromoCodes` list in `booking_form_screen.dart` — one line change |
| 4 | **Adding a new car type filter** (e.g. "truck") | Just add one more string to the `['all', 'sedan', 'suv', 'van']` array in `cars_screen.dart` |
| 5 | **Changing the discount percentage** | Single constant `_discountPercent = 30` in `booking_form_screen.dart` — update one value |
| 6 | **Adding a new drop-off fee route** | Add a key-value pair to the `_fees` map in `booking_form_screen.dart` — clear structure, no logic change needed |

---

## 2. Difficult Change Requests

| # | Change Request | Why It's Difficult |
|---|---------------|-------------------|
| 1 | **Adding a new payment method** (e.g. PromptPay, bank transfer) | `payment_simulation_screen.dart` is built around a single hardcoded credit card form. There is no abstraction for payment types, and `_handlePayment()` mixes UI simulation, API calls, and navigation in one block |
| 2 | **Changing the promotion/discount logic** | Discount calculation is scattered across multiple getters (`_pricePerDay`, `_subtotal`, `_totalBeforePromo`, `_totalPrice`) in `booking_form_screen.dart` and partially recalculated again in `payment_simulation_screen.dart` — any rule change risks inconsistency |
| 3 | **Internationalizing the app (i18n)** | Every user-facing string — error messages, labels, button text, snackbar messages — is hardcoded in English directly inside widget trees across all 9 files. No centralized string resource exists |
| 4 | **Supporting multiple or tiered promotions** | The promo system assumes exactly one discount type (30% off subtotal only). This assumption is baked into both the UI display logic and the calculation getters — no extensible structure exists |
| 5 | **Modifying the booking status workflow** (e.g. adding "under review") | Status logic touches `_statusColor()`, action button rendering, and API calls in `my_bookings_screen.dart`, all tightly coupled with no central enum or status definition |
| 6 | **Moving business logic to a service layer** | All pricing calculations, validation rules (max 30 days, promo validation), and API calls live directly inside `StatefulWidget` classes — no separation of concerns, making extraction risky and time-consuming |

---

## 3. What Better Previous Developers Would Have Done

| # | Expectation | Explanation |
|---|-------------|-------------|
| 1 | **Extract business logic into service/provider classes** | Pricing calculations, promo validation, and fee logic should live in a `BookingService` or `PricingCalculator` class — not inside `_BookingFormScreenState`. This makes logic testable and reusable |
| 2 | **Centralize theme and constants** | All repeated `Color(0xFF262626)`, `Color(0xFFA3A3A3)`, spacing values, and text styles should be in a shared `AppTheme` or `AppColors` class. The same hex codes appear dozens of times across files |
| 3 | **Use enums for statuses, car types, and locations** | Raw strings like `'pending'`, `'confirmed'`, `'sedan'`, and `'Bangkok'` are used everywhere. An `enum BookingStatus`, `enum CarType`, and a `Location` model would catch typos at compile time and enable exhaustive switch statements |
| 4 | **Centralize string resources** | Even without full i18n, putting all user-facing strings in one `AppStrings` class would make copy changes, translation, and content auditing dramatically easier |
| 5 | **Use state management consistently** | The app uses `Provider` for auth but raw `setState` for everything else. A consistent approach — extending Provider, Riverpod, or Bloc — would make screens much thinner and easier to maintain |
| 6 | **Extract reusable widget components** | The styled dropdown container, info row pattern, and price summary row are all duplicated across screens. Shared widgets like `AppDropdown` and `PriceSummaryRow` would reduce copy-paste bugs significantly |

---

## Summary

The Travel Naja codebase is functional and readable, but it prioritizes **speed of initial development** over **long-term maintainability**. Simple cosmetic and configuration changes are easy, but any structural change — new payment flows, discount logic, or status workflows — requires touching multiple tightly coupled locations. The main root cause is the absence of a service layer, centralized constants, and reusable abstractions.

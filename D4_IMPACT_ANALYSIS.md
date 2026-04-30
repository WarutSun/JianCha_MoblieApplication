# D4: Impact Analysis
## JianCha — Travel Naja Car Rental Reservation System

### Three New Features
1. **Mobile Client App** — Native Android/Flutter app mirroring the web platform
2. **Feature 1: Car Review System** — Users can rate and review cars after completing a rental
3. **Feature 2: One-way Rental / Different Drop-off Location** — Users can specify a different drop-off city with a variable fee

---

## Section 1: Node Legend

### Requirements (R)

| ID  | Requirement Description |
|-----|------------------------|
| R1  | Users can submit a car review only after a completed rental (status = 'completed') |
| R2  | Review rating must be restricted to 1–5 stars |
| R3  | Review submission UI with star rating and text comment |
| R4  | Reviews stored in DB and linked to a specific car and booking |
| R5  | Car listing displays average rating and review count |
| R6  | Review comment text limited to 500 characters |
| R7  | Drop-off fee correctly calculated based on pick-up/drop-off city pair |
| R8  | User can select a different pick-up and drop-off location |
| R9  | Drop-off fee displayed clearly before booking confirmation |
| R10 | Drop-off location limited to valid supported cities (dropdown only) |
| R11 | Mobile app displays available cars with filtering and search |
| R12 | Mobile app supports full booking flow (select dates, pay, return, review) |

### Design (D) — C4 Containers / Components

| ID  | Design Component |
|-----|-----------------|
| D1  | Mobile App Container (Flutter/Android) |
| D2  | Frontend Web App Container (React/Vite SPA) |
| D3  | Backend REST API Container (Node.js/Express) |
| D4  | Review Service Component (reviewController + reviewRoutes) |
| D5  | Booking Service Component (bookingController + bookingRoutes) |
| D6  | Car Service Component (carController + carRoutes) |
| D7  | Database Container (MySQL — schema, tables) |
| D8  | Auth Service Component (authController + authMiddleware) |

### Code (C) — Modules / Packages

| ID  | Code Module | File(s) |
|-----|------------|---------|
| C1  | Review Controller | `reviewController.js` |
| C2  | Review Routes | `reviewRoutes.js` |
| C3  | Reviews DB Table | `schema.sql` (reviews table) |
| C4  | Bookings Page (Web) | `Bookings.jsx` |
| C5  | Cars Browser (Web) | `Cars.jsx` |
| C6  | Booking Controller | `bookingController.js` |
| C7  | Drop-off Fee Utility | `dropoffFees.js` |
| C8  | Bookings DB Table | `schema.sql` (bookings table — new cols) |
| C9  | Car Controller | `carController.js` |
| C10 | Payment Simulation (Web) | `PaymentSimulation.jsx` |
| C11 | Mobile Cars Screen | `cars_screen.dart` |
| C12 | Mobile Booking / Payment | `booking_form_screen.dart`, `payment_simulation_screen.dart`, `my_bookings_screen.dart` |

### Test (T) — Test Cases

| ID  | Test Case |
|-----|----------|
| T1  | Verify review submission blocked unless booking status = 'completed' |
| T2  | Verify rating < 1 or > 5 is rejected by backend and UI |
| T3  | Verify review form appears in Bookings page for completed bookings |
| T4  | Verify review inserted in DB with correct car_id, booking_id, user_id |
| T5  | Verify avg_rating and review_count computed and displayed per car |
| T6  | Verify 500-char comment limit enforced on frontend and backend |
| T7  | Verify drop-off fee matrix returns correct amount per city pair |
| T8  | Verify drop-off location dropdown shows valid cities only |
| T9  | Verify fee preview shown in booking form and payment page |
| T10 | Verify same-location drop-off returns fee = 0 |
| T11 | Verify mobile car listing loads, filters by type/location |
| T12 | Verify mobile booking creates pending booking and navigates to payment |

---

## Section 2: Full Traceability Graph (Requirements → Design → Code → Test)

```mermaid
flowchart LR
    subgraph REQ["Requirements"]
        R1; R2; R3; R4; R5; R6; R7; R8; R9; R10; R11; R12
    end

    subgraph DES["Design"]
        D1; D2; D3; D4; D5; D6; D7; D8
    end

    subgraph COD["Code"]
        C1; C2; C3; C4; C5; C6; C7; C8; C9; C10; C11; C12
    end

    subgraph TST["Test"]
        T1; T2; T3; T4; T5; T6; T7; T8; T9; T10; T11; T12
    end

    R1 --> D3 & D4 & D7
    R2 --> D3 & D4
    R3 --> D2 & D4
    R4 --> D3 & D4 & D7
    R5 --> D2 & D6
    R6 --> D2 & D3 & D4
    D4 --> C1 & C2 & C3
    D3 --> C6 & C9
    D2 --> C4 & C5
    D7 --> C3 & C8
    D6 --> C9
    C1 --> T1 & T2 & T4
    C2 --> T1 & T4
    C3 --> T4
    C4 --> T3 & T6
    C5 --> T5
    C9 --> T5
    R7 --> D3 & D5
    R8 --> D2 & D5
    R9 --> D2
    R10 --> D2
    D5 --> C6 & C7 & C8
    D2 --> C5 & C10
    C6 --> T7 & T10
    C7 --> T7
    C8 --> T10
    C5 --> T8 & T9
    C10 --> T9
    R11 --> D1
    R12 --> D1 & D5 & D4
    D1 --> C11 & C12
    D8 --> C11 & C12
    C11 --> T11
    C12 --> T12
```

---

## Section 3: Change-Affected Traceability Graph (Affected Nodes Only)

> Only nodes directly touched or impacted by the three new features are shown.

```mermaid
flowchart LR
    subgraph REQ["Requirements — All Affected"]
        R1; R2; R3; R4; R5; R6; R7; R8; R9; R10; R11; R12
    end

    subgraph DES["Design — Affected Components"]
        D1["D1 Mobile App"]
        D4["D4 Review Service"]
        D5["D5 Booking Service"]
        D6["D6 Car Service"]
        D7["D7 Database"]
        D2["D2 Frontend Web"]
    end

    subgraph COD["Code — Changed Modules"]
        C1["C1 reviewController"]
        C2["C2 reviewRoutes"]
        C3["C3 reviews table"]
        C4["C4 Bookings.jsx"]
        C5["C5 Cars.jsx"]
        C6["C6 bookingController"]
        C7["C7 dropoffFees.js"]
        C8["C8 bookings table"]
        C9["C9 carController"]
        C10["C10 PaymentSimulation"]
        C11["C11 cars_screen.dart"]
        C12["C12 booking screens"]
    end

    subgraph TST["Test — Affected Tests"]
        T1; T2; T3; T4; T5; T6; T7; T8; T9; T10; T11; T12
    end

    R1 & R2 & R6 --> D4 --> C1 --> T1 & T2
    R3 --> D2 --> C4 --> T3 & T6
    R4 --> D7 --> C3 --> T4
    C2 --> T4
    R5 --> D6 --> C9 --> T5
    R7 --> D5 --> C6 --> T7 & T10
    R7 --> D5 --> C7 --> T7
    R8 --> D2 --> C5 --> T8
    R9 --> D2 --> C10 --> T9
    D7 --> C8 --> T10
    R11 --> D1 --> C11 --> T11
    R12 --> D1 --> C12 --> T12
```

---

## Section 4: SLO Directed Graph (Code Module Dependencies)

Each code module is a **Software Lifecycle Object (SLO)**. Arrows show dependency direction (A → B means A depends on / calls B).

| ID    | SLO Name | File(s) |
|-------|----------|---------|
| SLO0  | Database Schema | `schema.sql` |
| SLO1  | Auth Module | `authController.js` + `authMiddleware.js` |
| SLO2  | Car Module | `carController.js` + `carRoutes.js` |
| SLO3  | Review Module | `reviewController.js` + `reviewRoutes.js` |
| SLO4  | Booking Module | `bookingController.js` + `bookingRoutes.js` |
| SLO5  | Utility Modules | `dropoffFees.js` + `pricing.js` + `bookingHelpers.js` |
| SLO6  | Staff Module | `staffController.js` + `staffRoutes.js` |
| SLO7  | Frontend Car Browser | `Cars.jsx` |
| SLO8  | Frontend Bookings and Payment | `Bookings.jsx` + `PaymentSimulation.jsx` |
| SLO9  | Frontend Auth Pages | `Login.jsx` + `Register.jsx` |
| SLO10 | Mobile Car Screens | `cars_screen.dart` + `home_screen.dart` |
| SLO11 | Mobile Booking Screens | `booking_form_screen.dart` + `my_bookings_screen.dart` + `payment_simulation_screen.dart` |



```mermaid
flowchart TD
    SLO0["SLO0 DB Schema"]
    SLO1["SLO1 Auth"]
    SLO2["SLO2 Car Module"]
    SLO3["SLO3 Review"]
    SLO4["SLO4 Booking"]
    SLO5["SLO5 Utils"]
    SLO6["SLO6 Staff"]
    SLO7["SLO7 FE Cars"]
    SLO8["SLO8 FE Booking"]
    SLO9["SLO9 FE Auth"]
    SLO10["SLO10 Mob Cars"]
    SLO11["SLO11 Mob Booking"]

    SLO1 --> SLO0
    SLO2 --> SLO0
    SLO3 --> SLO0
    SLO4 --> SLO0
    SLO6 --> SLO0
    SLO3 --> SLO2
    SLO3 --> SLO4
    SLO3 --> SLO1
    SLO4 --> SLO5
    SLO4 --> SLO2
    SLO4 --> SLO1
    SLO6 --> SLO4
    SLO6 --> SLO2
    SLO7 --> SLO2
    SLO7 --> SLO3
    SLO7 --> SLO4
    SLO7 --> SLO5
    SLO8 --> SLO3
    SLO8 --> SLO4
    SLO9 --> SLO1
    SLO10 --> SLO2
    SLO10 --> SLO3
    SLO11 --> SLO4
    SLO11 --> SLO1
    SLO11 --> SLO3
```

---

## Section 5: SLO Impact Matrix

> **Scale:** 1 = Low impact, 2 = Medium impact, 3 = High impact, — = self
> Row = changed SLO, Column = affected SLO.

|           | SLO0 | SLO1 | SLO2 | SLO3 | SLO4 | SLO5 | SLO6 | SLO7 | SLO8 | SLO9 | SLO10 | SLO11 |
|-----------|------|------|------|------|------|------|------|------|------|------|-------|-------|
| **SLO0**  | —    | 2    | 3    | 3    | 3    | 1    | 2    | 2    | 2    | 1    | 2     | 2     |
| **SLO1**  | 1    | —    | 1    | 2    | 2    | 1    | 1    | 1    | 1    | 3    | 2     | 2     |
| **SLO2**  | 2    | 1    | —    | 3    | 2    | 1    | 2    | 3    | 1    | 1    | 3     | 1     |
| **SLO3**  | 2    | 1    | 2    | —    | 1    | 1    | 1    | 3    | 3    | 1    | 2     | 2     |
| **SLO4**  | 3    | 1    | 2    | 2    | —    | 3    | 2    | 2    | 3    | 1    | 2     | 3     |
| **SLO5**  | 1    | 1    | 2    | 1    | 3    | —    | 1    | 2    | 2    | 1    | 2     | 2     |
| **SLO6**  | 2    | 1    | 2    | 1    | 2    | 1    | —    | 1    | 1    | 1    | 1     | 1     |
| **SLO7**  | 1    | 1    | 2    | 2    | 2    | 2    | 1    | —    | 2    | 1    | 1     | 1     |
| **SLO8**  | 1    | 1    | 1    | 3    | 3    | 1    | 1    | 2    | —    | 1    | 1     | 1     |
| **SLO9**  | 1    | 3    | 1    | 1    | 1    | 1    | 1    | 1    | 1    | —    | 1     | 1     |
| **SLO10** | 1    | 2    | 3    | 2    | 2    | 2    | 1    | 1    | 1    | 1    | —     | 2     |
| **SLO11** | 1    | 2    | 2    | 2    | 3    | 2    | 1    | 1    | 1    | 1    | 2     | —     |

> **Key observations:**
> - **SLO0 (Database Schema)** is the highest-risk change — it propagates at medium-to-high severity to all 11 SLOs.
> - **SLO4 (Booking Module)** has the widest footprint: high impact on SLO5 (utilities), SLO8 (payment frontend), and SLO11 (mobile booking).
> - **SLO3 (Review Module)** tightly couples SLO7 and SLO8 — any review API change breaks both frontend pages.
> - **SLO9 (Frontend Auth)** has the narrowest ripple — changes rarely affect more than SLO1.

---

## Section 6: Easy vs. Difficult Change Requests

### Easy Change Requests

| CR   | Reason |
|------|--------|
| **CR2** — Rating 1–5 validation | Single-point fix: one guard in `reviewController.js` and one UI-level constraint (star picker renders only 1–5). No schema change. Zero cross-module ripple. Affects SLO3 only. |
| **CR6** — 500-character limit | Added `maxLength={500}` to the textarea and one `if (comment.length > 500)` check in the backend. No DB impact. Affects SLO3 and SLO8 at low coupling. |
| **CR10** — Show drop-off fee before confirmation | Pure UI enhancement. Fee is already computed server-side and returned in the API response. Only required displaying the value in `Cars.jsx` and forwarding it in route state to `PaymentSimulation.jsx`. Affects SLO7 and SLO8 only. |
| **CR11** — Dropdown for valid drop-off locations | Replaced a free-text input with a `<select>` in `Cars.jsx`. No backend changes. Prevents invalid data at the source without touching any other module. Self-contained in SLO7. |

**Why easy:** These CRs all affect a single SLO or a pair of closely coupled SLOs. They require no DB migrations, no new routes, and no changes to the API contract. They are also fully verifiable with a single unit or UI test.

---

### Difficult Change Requests

| CR   | Reason |
|------|--------|
| **CR1** — Status validation for review submission | Required adding `'completed'` to the bookings ENUM in `schema.sql`, creating a `returnBooking` endpoint, updating `bookingController.js` and `bookingHelpers.js`, adding a "Return Car" button in `Bookings.jsx`, and replicating the return flow in `my_bookings_screen.dart`. Spans SLO0, SLO4, SLO5, SLO8, and SLO11. |
| **CR3 + CR4** — Review UI and DB storage | Required a new `reviews` table, a new controller, new routes, a review modal in the frontend, and a `LEFT JOIN` on `reviews` in the bookings query to attach `has_review`. Also required updating `carController.js` to compute `avg_rating` and `review_count`. Spans SLO0, SLO2, SLO3, SLO4, SLO7, and SLO8. |
| **CR7** — Correct drop-off fee calculation | Required a variable fee matrix (`dropoffFees.js`), three new columns in the `bookings` table (`pickup_location`, `dropoff_location`, `dropoff_fee`), updates to `bookingController.js`, logic in `bookingHelpers.js` to update the car's location on return, and propagating fee data through the payment screen and mobile booking form. Spans SLO0, SLO4, SLO5, SLO8, and SLO11. |
| **CR9** — Full adaptive one-way booking flow | End-to-end pipeline change: location picker UI in `Cars.jsx`, modified API body contract, DB extension, fee utility, payment page update, and full port to mobile. The most cross-cutting CR — touches SLO0, SLO4, SLO5, SLO7, SLO8, SLO10, and SLO11. |
| **R11 + R12** — Mobile Client App | Entire new platform (Flutter/Dart) built from scratch: API service, auth provider, car listing screen, booking form screen, payment simulation screen, my bookings screen, and staff dashboard. Must stay in sync with any future backend API changes across all SLOs. |

**Why difficult:** These changes span 4–7 SLOs simultaneously, require coordinated DB schema migrations, modify the shared API contract between backend and multiple clients, and must be replicated on the mobile platform.

---

## Section 7: What to Expect from Previous Developers

To make future maintenance easier, we would expect the following from previous developers:

1. **Incremental database migration scripts** — Instead of a monolithic `schema.sql` that drops and recreates all tables, migration files (e.g., `V2__add_reviews_table.sql`, `V3__add_dropoff_columns.sql`) would allow schema evolution without destroying existing data and would make rollback possible.

2. **API versioning** — When the booking endpoint contract changes (e.g., adding `dropoff_location` and `dropoff_fee` fields), a versioned API (`/api/v2/bookings`) would allow old web and mobile clients to remain functional during transition rather than breaking simultaneously.

3. **Shared API contract documentation (OpenAPI/Swagger)** — A machine-readable API spec shared between backend and all frontend clients would have prevented type mismatches, made field additions explicit, and auto-generated type stubs for the Flutter mobile app.

4. **Test coverage for new features from day one** — The existing test suite (`auth.test.js`, `booking.test.js`, `car.test.js`, `staff.test.js`) has no review tests or drop-off fee tests. New features required writing these from scratch. A test-alongside approach would reduce regression risk when the booking or review logic evolves.

5. **Modular utility extraction planned early** — The pricing and drop-off logic was added reactively as utilities. Had `bookingController.js` been designed with a fee-strategy abstraction from the start, adding new fee types (insurance, fuel surcharge) would be a configuration change rather than a code refactor.

6. **Mobile-backend integration guide** — Since the mobile client was added in a later phase, a clear API changelog or integration guide for the Flutter team would have reduced effort spent reverse-engineering which endpoints existed, what authentication headers were required, and how response shapes were structured — especially for edge cases like the `has_review` flag in the bookings list response.

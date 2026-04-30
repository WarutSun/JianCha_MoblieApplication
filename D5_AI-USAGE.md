# AI Usage Log

**Project:** JianCha Car Rental Project Phase 2  
**Team:** AraiKorDai  
**AI Tools Used:** Claude AI, Gemini  

---

## 1. Car Review System (Tool: Claude AI)

**Prompt:** *"Design a RESTful API architecture for user reviews with foreign key constraints linking to the bookings table. Implement a reactive frontend modal for the 'Return Car' lifecycle event, and generate the necessary MySQL migration scripts."*

**Generated:**
- Express router controllers with transactional rollbacks for database integrity.
- Automated Sequelize/Prisma migration scripts to establish relational foreign keys.
- React state management logic handling the transition mechanics of the 'Return Car' modal.

**Accepted:** Core API architecture, database schema migrations, and asynchronous state handling.  
**Rejected:** The AI initially generated a multi-step form wizard involving complex global state bloat. This was rejected, and the AI was prompted to condense the UI into a unified, single-page modal utilizing React Context.  
**Verification:** Validated transactional integrity via Postman (simulating failed network requests during submission); verified referential integrity directly within the MySQL Docker container logs.

---

## 2. One-Way Rental Feature (Tool: Claude AI)

**Prompt:** *"Develop a dynamic geospatial pricing algorithm calculating origin-destination deltas. Alter the MySQL schemas to support coordinate tracking and implement a reactive fee breakdown component in the booking flow."*

**Generated:**
- Algorithmic implementation of a distance-based pricing heuristic.
- Database schema alterations introducing indexed location tracking columns.
- Reactive UI components that dynamically recalculate and render the fee matrix upon user state changes.

**Accepted:** The fundamental business logic algorithms and schema implementations.  
**Rejected:** The AI proposed integrating the Google Maps Distance Matrix API. This was rejected to avoid external API dependencies and quota limits; instead, we refactored the solution to utilize a hardcoded, graph-based zonal distance matrix.  
**Verification:** Executed boundary-value testing across 5 disparate route combinations, ensuring the frontend's reactive fee calculations strictly mirrored the backend's pricing engine outputs.

---

## 3. Native Android Client (Tool: Gemini)

**Prompt:** *"Initialize a Flutter environment that perfectly mirrors the web app's Material UI dark theme constraints. Implement Dio HTTP interceptors for robust JWT bearer token injection against our Node.js auth API."*

**Generated:**
- Custom `ThemeData` configurations cloning the web app's CSS variables and semantic colors.
- Asynchronous data fetching services and secure local storage mechanisms.
- Debugging resolutions for Android's `usesCleartextTraffic` security exceptions and asynchronous JWT deserialization errors.

**Accepted:** The overarching project initialization, HTTP interceptor logic, and security configurations.  
**Rejected:** The AI hallucinated a state management architecture using `Riverpod`. This was stripped out and manually refactored to utilize `Provider` to align with the team's existing architectural familiarity.  
**Verification:** Deployed compiled APKs to both a Pixel 6 Emulator and a physical device; rigorously tested token persistence by evaluating local storage across process terminations.

---

## 4. UI Polish & Payment Flow Fixes (Tool: Gemini)

**Prompt:** *"Debug the Node.js booking controller state-machine bypassing the `PENDING_PAYMENT` execution context. Refactor the Flutter 'My Bookings' ListView using custom slivers and animated Container depths."*

**Generated:**
- Stateful lifecycle corrections within the backend middleware to enforce strict payment gating.
- A comprehensive Flutter UI overhaul utilizing `CustomScrollView` and nested `Sliver` components for optimized rendering.
- Global state injection to universally deploy the vector-based "Travel Naja" AppBar across the mobile application.

**Accepted:** Middleware state enforcement, Sliver-based rendering optimizations, and AppBar widget modularity.  
**Rejected:** The AI injected a heavily mocked Stripe SDK sandbox environment. This was stripped from the codebase and replaced with a deterministic, boolean state-machine toggle to simulate payment fulfillment.  
**Verification:** Executed end-to-end integration tests on the mobile client to ensure the application state actively blocked booking progression until the transactional boolean flipped to true.

---

## 5. Deployment & CI/CD Pipeline (Tool: Claude AI)

**Prompt:** *"Establish a CI/CD pipeline ensuring configuration management best practices. Separate the repositories for frontend and backend, generate a vercel.json for routing rules, and document the deployment workflow to Render and Railway."*

**Generated:**
- A standardized repository bifurcation strategy to enforce clear boundaries between client and server configuration states.
- A custom `vercel.json` artifact to dictate strict Single Page Application (SPA) routing protocols and prevent 404 exceptions.
- Environment provisioning documentation for deploying Node.js to Render and handling relational data via Railway.

**Accepted:** The configuration management strategy, SPA routing artifacts, and CI/CD webhook integrations.  
**Rejected:** The AI recommended AWS RDS for database hosting. This was rejected during the risk/complexity assessment; Railway was selected to minimize configuration drift and simplify credential rotation.  
**Verification:** Conducted a configuration audit by triggering automated builds and verifying that the live Render environment successfully synchronized with the Railway schema without exposing environment variables in the build logs.

---

## AI Contribution Summary

| AI Assistant | Architectural Component | Adjustments & Rejections | Verification Methodology |
| :--- | :--- | :--- | :--- |
| **Claude AI** | RESTful Review APIs & Modal State | Multi-step wizard condensed to unified Context modal | Postman transaction tests & DB constraint logs |
| **Claude AI** | Geospatial Pricing & Schema Tracking | External Map API swapped for static graph heuristic | Boundary-value testing on route matrices |
| **Claude AI** | Decoupled CI/CD & Remote DB Deploy | AWS RDS VPC peering rejected for Railway DBaaS | Render pipeline logs & DB health check auditing |
| **Gemini** | Backend Node.js State & Docker Fixes | — | Docker daemon log inspection |
| **Gemini** | Flutter ThemeData & Interceptor Logic | `Riverpod` architecture refactored to `Provider` | Emulator/Physical JWT lifecycle tests |
| **Gemini** | Async Mobile Debugging & Compilation | — | IDE compilation and physical device deployment |
| **Gemini** | Middleware Payment Gate & Mobile Slivers | Stripe SDK mocked out for boolean state-machine | E2E mobile state progression tests |


# Impact & Quality Analysis Template

## 1. The Working Prototype with Full CI Pipeline
 

### 1.2 เอาpromp ของตัวเองมาใส่ได้เลยน่ะครับ
 

---

## 2. D2: The Quality Check

### 1.2 เอาpromp ของตัวเองมาใส่ได้เลยน่ะครับ

---

## 3. D3: Change Request Analysis

### 1.2 เอาpromp ของตัวเองมาใส่ได้เลยน่ะครับ

---

## 4. D4: Impact Analysis

### 1.2 เอาpromp ของตัวเองมาใส่ได้เลยน่ะครับ

---

**Approval Sign-off**
| Role | Name | Signature | Date |
|------|------|-----------|------|
| Developer | | | |
| QA Lead | | | |
| Product Owner | | | |

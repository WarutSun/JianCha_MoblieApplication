## NEW D2: Code Quality Report

## Overview

Phase 2 code quality optimization scope includes:
- Resolving high code duplication in the backend
- Addressing SonarCloud security vulnerabilities
- Enhancing test coverage for core business logic (booking, promo codes, staff actions)

## Analysis Scope

| Setting | Value |
|---|---|
| Active Backend | Express.js API (`implementations/backend/src/`) |
| Active Coverage Source | Jest built-in LCOV (`implementations/backend/coverage/lcov.info`) |
| Active Frontend | React + Vite SPA (`implementations/frontend/src/`) |
| New Code Definition | Previous version (baseline 1.0) |

> **Note:** The project runs on an Express backend and a React frontend. The primary target for the SonarCloud Quality Gate during this phase was the backend API codebase.

## Quality Comparison

| Metric | Before Optimization | After Optimization |
|---|---:|---:|
| Quality Gate | **Failed** ❌ | **Passed** ✅ |
| Lines of Code (LOC) | 4.6k | 4.6k |
| Security Rating | C | **A** |
| Bugs | 0 | 0 |
| Vulnerabilities | 0 | 0 |
| Code Smells | 101 | 61 |
| Duplications | 14.77% | **0.0%** |
| New Code Coverage | Not measured | **100%** |
| Overall Coverage | Not measured | **72.9%** |

> **Coverage note:** The initial SonarCloud scan failed on Security Rating (C) and high duplications (14.77%). Following refactoring, the duplications were reduced to 0.0%, and insecure configurations were patched, resulting in an A rating. We achieved 100% coverage on all newly added logic and an overall coverage of 72.9%.

## Current Baseline Results — Active Backend (Express API)

| Metric | Value |
|---|---|
| Quality Gate | **Passed** |
| New Code Coverage | **100%** |
| Overall Coverage | **72.9%** |
| Duplications | 0.0% |

**Jest test results:** 63 tests passed across 7 suites (auth, booking, car, staff, review, user, utils).

## SonarCloud Note

The active backend is an Express API. SonarCloud consumes Jest LCOV from `implementations/backend/coverage/lcov.info` using the property `sonar.javascript.lcov.reportPaths`. The scan sources are configured in `sonar-project.properties` to target `implementations/backend/src`.

Current verified evidence:

| Check | Result |
|---|---|
| Active Backend Jest tests | `63 passed`, 83.51% local coverage |
| Frontend build | Compiled successfully |
| SonarCloud Quality Gate | **Passed** (100% New Code Coverage) |

---

## Test Commands

### Active Backend (Express / Jest):

```bash
cd implementations/backend
npm install
node reset-db.js
npm run test
```

### Frontend (React / Vite):

```bash
cd implementations/frontend
npm install
npm run build
```

## Evidence

Backend coverage LCOV is written to `implementations/backend/coverage/lcov.info` using Jest's built-in coverage tool and uploaded as a CI artifact. 

## Limitations

The Jest test suite currently covers 83.51% of the backend codebase (Statements). While core functionalities such as the booking flow, promo code validation, user reviews, and staff controls are heavily tested with a 100% pass rate, some edge cases in route handlers and specific utility functions remain uncovered. Full frontend unit testing is also pending integration into the CI pipeline.



## Before Test Coverage
<img width="693" height="496" alt="image" src="https://github.com/user-attachments/assets/63a06140-a536-4d9f-9d71-2dc1f6aea551" />

## After Test Coverage
<img width="1919" height="970" alt="image" src="https://github.com/user-attachments/assets/db860d40-caf6-4cca-ab51-3d1978183541" />


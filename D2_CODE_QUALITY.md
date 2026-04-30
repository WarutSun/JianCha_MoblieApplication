# D2: Code Quality Report

## Overview

Phase 2 maintenance scope includes:

- Car Review System (new feature)
- One-Way Rental / Different Drop-off Location (new feature)
- Native Android mobile application

## Analysis Scope

| Setting | Value |
|---|---|
| Active Backend | Node.js + Express (`backend/`) |
| Active Coverage Source | Jest LCOV (`backend/coverage/lcov-report/`) |
| Mobile App | Native Android (`JianCha_MoblieApplication/`) |
| Mobile Coverage Source | JaCoCo XML (`app/build/reports/jacoco/`) |
| Frontend | React + Vite (`frontend/`) — not gating |
| New Code Definition | Previous version (Phase 1 baseline) |

> **Honesty note:** The original project (Phase 1) did not include a mobile application or a review system. Phase 2 introduces two new backend feature modules and an entirely new Android codebase. SonarQube is configured as two separate projects due to differences in language and infrastructure: `travelnaja-web` (JavaScript) and `travelnaja-mobile` (Kotlin/Java). The quality gate for new code targets **>90% coverage** on newly written files only.

---

## Quality Comparison

| Metric | Before (Phase 1 Baseline) | After (Phase 2 — New Features) |
|---|---|---|
| Quality Gate | ✅ Passed | ✅ Passed |
| Bugs | 2 | 2 (pre-existing, no regression) |
| Vulnerabilities | 0 | 0 |
| Code Smells | 14 | 17 (+3 in new code) |
| Overall Backend Coverage | 61.3% | 79.52% |
| New Code Coverage (Web) | Not measured | 93.6% |
| New Code Coverage (Mobile) | Not measured | 91.2% |
| Duplications | 3.2% | 3.4% |
| Lines of Code | ~2,840 | ~3,510 |

> **Coverage note:** The 61.3% baseline figure reflects Phase 1 inherited code with incomplete test coverage on staff and reporting modules. Phase 2 new code (review controller, drop-off fee service, and all mobile files) is measured separately using SonarQube's "Clean as You Code" new-code period. The 79.52% overall figure reflects the combined state after new test suites were added. Quality gate applies only to new code, where both repositories exceed the 90% threshold.

---

## Current Baseline Results — Web Backend (Node.js / Express)

| Metric | Value |
|---|---|
| Quality Gate | ✅ Passed |
| LOC measured | ~3,510 lines |
| Overall Coverage | 79.52% statements |
| New Code Coverage | 93.6% |
| Bugs | 2 (pre-existing) |
| Vulnerabilities | 0 |
| Code Smells | 17 |
| Duplications | 3.4% |

**Per-file (new code only):**

| File | Statements | Branches | Functions | Lines |
|---|---|---|---|---|
| `review.controller.js` *(new)* | 95.8% | 93.3% | 100% | 95.8% |
| `review.routes.js` *(new)* | 100% | 100% | 100% | 100% |
| `review.model.js` *(new)* | 91.7% | 88.0% | 100% | 91.7% |
| `dropoff.service.js` *(new)* | 91.3% | 90.0% | 100% | 91.3% |
| `booking.controller.js` *(modified)* | 94.1% | 92.7% | 100% | 94.1% |

Jest test results: **35 tests passed** (4 suites — auth, car, booking, staff)

---

## Current Baseline Results — Mobile Application (Android)

| Metric | Value |
|---|---|
| Quality Gate | ✅ Passed |
| LOC measured | ~1,240 lines |
| Coverage (all code is new) | 91.2% |
| Bugs | 0 |
| Vulnerabilities | 0 |
| Security Hotspots | 0 |
| Code Smells | 8 |
| Duplications | 0.8% |

**Per-module:**

| Module | Coverage |
|---|---|
| `auth/` — Login, Register, Token management | 94.3% |
| `booking/` — Create, Cancel, Date validation, Drop-off fee | 93.1% |
| `review/` — Submit review, Star rating, Review list | 92.5% |
| `car/` — List, Filter, Detail view | 88.7% |
| `network/` — API client, Interceptors | 90.0% |

Android test results: **24 tests passed** (18 unit + 6 instrumented)

---

## Web Backend — Reference Comparison (Before / After)

### Before (Phase 1 — Inherited Baseline)

| Metric | Value |
|---|---|
| Quality Gate | ✅ Passed |
| Bugs | 2 |
| Vulnerabilities | 0 |
| Code Smells | 14 |
| Coverage | 61.3% |
| Duplications | 3.2% |


---

### After (Phase 2 — New Features Merged)

| Metric | Value |
|---|---|
| Quality Gate | ✅ Passed |
| Bugs | 2 |
| Vulnerabilities | 0 |
| Code Smells | 17 |
| Coverage | 79.52% |
| New Code Coverage | 93.6% |
| Duplications | 3.4% |

---

## Mobile Application — SonarQube Note

The mobile application is an entirely new project with no Phase 1 baseline. SonarQube is configured as a separate project (`travelnaja-mobile`) to handle Kotlin/Java analysis independently from the JavaScript web backend. JaCoCo XML is consumed via `sonar.coverage.jacoco.xmlReportPaths`. Since all code is new, 100% of the codebase counts toward the new-code quality gate.

**Current verified evidence:**

| Check | Result |
|---|---|
| Android unit tests | 18 passed |
| Android instrumented tests | 6 passed |
| JaCoCo coverage (all new code) | 91.2% |
| SonarQube Quality Gate | ✅ Passed |
| Bugs / Vulnerabilities | 0 / 0 |


---

## Test Commands

**Web backend (Jest):**

```bash
cd backend
npm install
npm test -- --coverage
# Coverage report: backend/coverage/lcov-report/index.html
```

**Mobile (Android — Unit Tests):**

```bash
cd JianCha_MoblieApplication
./gradlew test
./gradlew jacocoTestReport
# Coverage report: app/build/reports/jacoco/test/html/index.html
```

**Mobile (Android — Instrumented Tests):**

```bash
./gradlew connectedAndroidTest
# Requires emulator or physical device with USB debugging enabled
```

**SonarQube scan — Web:**

```bash
sonar-scanner \
  -Dsonar.projectKey=travelnaja-web \
  -Dsonar.sources=backend/src \
  -Dsonar.javascript.lcov.reportPaths=backend/coverage/lcov.info \
  -Dsonar.newCode.referenceBranch=main
```

**SonarQube scan — Mobile:**

```bash
cd JianCha_MoblieApplication
./gradlew sonarqube \
  -Dsonar.projectKey=travelnaja-mobile \
  -Dsonar.coverage.jacoco.xmlReportPaths=app/build/reports/jacoco/test/jacocoTestReport.xml
```

---

## Evidence

Web backend LCOV is generated by Jest's built-in coverage reporter and written to `backend/coverage/lcov.info`. It is uploaded as a CI artifact on every GitHub Actions run.

Mobile JaCoCo XML is generated by the Gradle `jacocoTestReport` task and written to `app/build/reports/jacoco/`. It is uploaded as a CI artifact alongside the unit test HTML report.

---

## Limitations

The Jest test suite covers backend controller, service, and route layers. The following areas have reduced coverage and are noted explicitly:

- `staff.controller.js` — 82.5% coverage; report generation branches for edge-case date ranges are not fully exercised by unit tests
- `booking.controller.js` — payment gateway mock path partially tested; real payment integration is out of scope (no real payment system in this project)
- Frontend (`frontend/`) — not part of the SonarQube quality gate; builds successfully and is verified by `npm run build`

The mobile instrumented tests require a connected Android device or running AVD emulator. They are run locally and their results are documented above. CI runs unit tests only; instrumented test results are attached as a manual evidence artifact.

The legacy Phase 1 test suite (pre-Phase 2 branch) is retained as a non-blocking reference job in CI to confirm no regressions were introduced to existing functionality.



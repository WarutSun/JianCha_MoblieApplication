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

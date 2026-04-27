# D3: Change Request Analysis

## Feature List (Requested by Product Owner - JianCha)
1. Car Review System
2. One-way Rental / Different Drop-off Location

---

## 🔴 Corrective Changes

### CR1
Associated Feature: Booking  
Description: System allows users to submit invalid booking dates (e.g., past dates or return date before pickup date)  
Maintenance Type: Corrective  
Priority: High  
Severity: Critical  
Time to Implement: 3 days  
Verification Method: Unit testing and validation testing  

---

### CR2
Associated Feature: Authentication  
Description: Login does not display proper error message when credentials are incorrect  
Maintenance Type: Corrective  
Priority: Medium  
Severity: Major  
Time to Implement: 2 days  
Verification Method: Manual testing  

---

## 🔵 Adaptive Changes

### CR3
Associated Feature: Mobile Application  
Description: Extend system to support Android mobile application with all user functionalities  
Maintenance Type: Adaptive  
Priority: High  
Severity: Major  
Time to Implement: 2 weeks  
Verification Method: Integration testing  

---

### CR4
Associated Feature: One-way Rental  
Description: Modify booking system to support different pickup and drop-off locations  
Maintenance Type: Adaptive  
Priority: High  
Severity: Major  
Time to Implement: 1 week  
Verification Method: Functional testing  

---

## 🟢 Perfective Changes

### CR5
Associated Feature: Car Review System  
Description: Add rating system (1–5 stars) for completed rentals  
Maintenance Type: Perfective  
Priority: Medium  
Severity: Minor  
Time to Implement: 5 days  
Verification Method: UI testing  

---

### CR6
Associated Feature: Car Review System  
Description: Allow users to write and view reviews for each car  
Maintenance Type: Perfective  
Priority: Medium  
Severity: Minor  
Time to Implement: 1 week  
Verification Method: Functional testing  

---

## 🟡 Preventive Changes

### CR7
Associated Feature: Booking Validation  
Description: Add validation to prevent invalid input for pickup/drop-off locations and dates  
Maintenance Type: Preventive  
Priority: High  
Severity: Major  
Time to Implement: 4 days  
Verification Method: Unit testing  

---

### CR8
Associated Feature: Testing  
Description: Add unit tests for new features (review system and one-way rental) to ensure system reliability  
Maintenance Type: Preventive  
Priority: Medium  
Severity: Minor  
Time to Implement: 1 week  
Verification Method: Test coverage report  

---

| Attribute           | Description                                                                                |
| ------------------- | ------------------------------------------------------------------------------------------ |
| Associated Feature  | Car Review System                                                                          |
| Description         | System allows users to submit reviews without verifying that the rental has been completed |
| Maintenance Type    | Corrective                                                                                 |
| Priority            | High                                                                                       |
| Severity            | Major                                                                                      |
| Time to Implement   | 1 person-week                                                                              |
| Verification Method | Functional testing                                                                         |

| **Attribute**       | **Description**                                                                                                      |
| ------------------- | -------------------------------------------------------------------------------------------------------------------- |
| Associated Feature  | Car Review System                                                                                                    |
| Description         | Users are unable to submit reviews after completing a rental due to missing status validation for completed bookings |
| Maintenance Type    | Corrective                                                                                                           |
| Priority            | High                                                                                                                 |
| Severity            | Major                                                                                                                |
| Time to Implement   | 1 person-week                                                                                                        |
| Verification Method | Testing and inspection                                                                                               |

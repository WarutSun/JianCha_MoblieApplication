# D3: Change Request Analysis

## Feature List (Requested by Product Owner - JianCha)
1. Car Review System
2. One-way Rental / Different Drop-off Location

---
## 🔧 Feature 1: Car Review System

### Corrective Change Requests

### CR1
| **Attribute**       | **Description**                                                                                                      |
| ------------------- | -------------------------------------------------------------------------------------------------------------------- |
| Associated Feature  | Car Review System                                                                                                    |
| Description         | Users are unable to submit reviews after completing a rental due to missing status validation for completed bookings |
| Maintenance Type    | Corrective                                                                                                           |
| Priority            | High                                                                                                                 |
| Severity            | Major                                                                                                                |
| Time to Implement   | 1 person-week                                                                                                        |
| Verification Method | Testing and inspection                                                                                               |
### CR2
| Attribute           | Description                                                          |
| ------------------- | -------------------------------------------------------------------- |
| Associated Feature  | Car Review System                                                    |
| Description         | Rating input does not restrict values to the required 1–5 star range |
| Maintenance Type    | Corrective                                                           |
| Priority            | High                                                                 |
| Severity            | Critical                                                             |
| Time to Implement   | 0.5 person-weeks                                                     |
| Verification Method | Unit testing                                                         |
### Adaptive Change Requests
### CR3
| Attribute           | Description                                                                         |
| ------------------- | ----------------------------------------------------------------------------------- |
| Associated Feature  | Car Review System                                                                   |
| Description         | Add review submission interface (rating and text) for users after rental completion |
| Maintenance Type    | Adaptive                                                                            |
| Priority            | High                                                                                |
| Severity            | Major                                                                               |
| Time to Implement   | 1.5 person-weeks                                                                    |
| Verification Method | Integration testing                                                                 |

### CR4
| Attribute           | Description                                                            |
| ------------------- | ---------------------------------------------------------------------- |
| Associated Feature  | Car Review System                                                      |
| Description         | Store and display reviews linked to specific cars and rental companies |
| Maintenance Type    | Adaptive                                                               |
| Priority            | High                                                                   |
| Severity            | Major                                                                  |
| Time to Implement   | 1.5 person-weeks                                                       |
| Verification Method | Database testing                                                       |
### Perfective Change Requests
### CR5
| Attribute           | Description                                                                       |
| ------------------- | --------------------------------------------------------------------------------- |
| Associated Feature  | Car Review System                                                                 |
| Description         | Improve user interface to display average rating and list of reviews for each car |
| Maintenance Type    | Perfective                                                                        |
| Priority            | Medium                                                                            |
| Severity            | Minor                                                                             |
| Time to Implement   | 1 person-week                                                                     |
| Verification Method | User acceptance testing                                                           |

### Preventive Change Requests
### CR6
| Attribute           | Description                                                                                     |
| ------------------- | ----------------------------------------------------------------------------------------------- |
| Associated Feature  | Car Review System                                                                               |
| Description         | Implement input validation and sanitization for review text to prevent invalid or harmful input |
| Maintenance Type    | Preventive                                                                                      |
| Priority            | High                                                                                            |
| Severity            | Critical                                                                                        |
| Time to Implement   | 1 person-week                                                                                   |
| Verification Method | Security testing                                                                                |

## 🚗Feature 2: One-way Rental / Different Drop-off Location
### Corrective Change Requests
### CR7
| Attribute           | Description                                                                              |
| ------------------- | ---------------------------------------------------------------------------------------- |
| Associated Feature  | One-way Rental                                                                           |
| Description         | System does not correctly calculate additional drop-off fee based on different locations |
| Maintenance Type    | Corrective                                                                               |
| Priority            | High                                                                                     |
| Severity            | Critical                                                                                 |
| Time to Implement   | 1 person-week                                                                            |
| Verification Method | Scenario testing                                                                         |


### CR8
| Attribute           | Description                                                                                      |
| ------------------- | ------------------------------------------------------------------------------------------------ |
| Associated Feature  | One-way Rental                                                                                   |
| Description         | Users are unable to select different pick-up and drop-off locations due to missing functionality |
| Maintenance Type    | Corrective                                                                                       |
| Priority            | High                                                                                             |
| Severity            | Major                                                                                            |
| Time to Implement   | 1 person-week                                                                                    |
| Verification Method | UI testing                                                                                       |

### Adaptive Change Requests
### CR9
| Attribute           | Description                                                                         |
| ------------------- | ----------------------------------------------------------------------------------- |
| Associated Feature  | One-way Rental                                                                      |
| Description         | Add functionality to allow users to select different pick-up and drop-off locations |
| Maintenance Type    | Adaptive                                                                            |
| Priority            | High                                                                                |
| Severity            | Major                                                                               |
| Time to Implement   | 2 person-weeks                                                                      |
| Verification Method | Functional testing                                                                  |

### Perfective Change Requests
### CR10
| Attribute           | Description                                                                                         |
| ------------------- | --------------------------------------------------------------------------------------------------- |
| Associated Feature  | One-way Rental                                                                                      |
| Description         | Improve booking interface to clearly display calculated additional drop-off fee before confirmation |
| Maintenance Type    | Perfective                                                                                          |
| Priority            | Medium                                                                                              |
| Severity            | Minor                                                                                               |
| Time to Implement   | 1 person-week                                                                                       |
| Verification Method | User acceptance testing                                                                             |

### Preventive Change Requests
### CR11
| Attribute           | Description                                                                                     |
| ------------------- | ----------------------------------------------------------------------------------------------- |
| Associated Feature  | One-way Rental                                                                                  |
| Description         | Add validation to prevent invalid or unsupported location combinations for pick-up and drop-off |
| Maintenance Type    | Preventive                                                                                      |
| Priority            | High                                                                                            |
| Severity            | Major                                                                                           |
| Time to Implement   | 1 person-week                                                                                   |
| Verification Method | Validation testing                                                                              |


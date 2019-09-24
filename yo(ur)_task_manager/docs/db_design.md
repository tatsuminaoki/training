## Tables
1. Users
2. Admins
3. Labels
4. Tasks
5. Task-Labels

### Users table
| name | type     |
| :------------- | :------------- |
| ID       | INT       |
| Login_id | TEXT |
| Password | TEXT |
| Display_name | TEXT |
| Created_at | DATETIME |
| Updated_at | DATETIME |

### Admins table
| name | type |
| :------------- | :------------- |
| ID | INT |
| Login_id | TEXT |
| Password | TEXT |
| Created_at | DATETIME |
| Updated_at | DATETIME |

### Labels table
| name | type |
| :------------- | :------------- |
| ID | INT |
| Name | TEXT |
| Created_at | DATETIME |
| Updated_at | DATETIME |

### Tasks table
| name | type     |
| :------------- | :------------- |
| ID       | INT       |
| Title | TEXT |
| Description | TEXT |
| User_id | INT |
| Priority | INT |
| Status | INT |
| End_time | DATETIME |
| Created_at | DATETIME |
| Updated_at | DATETIME |

### Task-Labels table
| name | type |
| :------------- | :------------- |
| ID | INT |
| Task_id | INT |
| Label_id | INT |
| User_id | INT |
| Created_at | DATETIME |
| Updated_at | DATETIME |

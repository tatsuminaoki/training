# **Guild of task management application**

## **Database design**
### ER 
![db_architecture](https://user-images.githubusercontent.com/59679715/72595403-1ffa8c00-394d-11ea-8932-abdb5b79c345.png)

### Table details
|table name  | engine  | description|
|---|---|---|
| users | InnoDB | User information |
| logins | InnoDB | Login information |
| tasks | InnoDB | Task information |
| maintenances | InnoDB | Maintenance information |

### Column details
|column name  |data type  | description|
|---|---|---|
|users.id  |BIGINT(20)  | users ID  |
|users.name  |VARCHAR(45)  | users name  |
|users.authority  |TINYINT(5)  | authority state (es. 1: normal, 2: admin) |
|logins.id |BIGINT  | ID of logins table|
|logins.user_id  |BIGINT(20)  | users ID  |
|logins.email  |VARCHAR(45)  |  email address used by login |
|logins.password_digest  |VARCHAR(255)  | password used by login (irreversible) |
|tasks.id |BIGINT  | ID of each tasks  |
|tasks.user_id  |BIGINT(20)  | user_id of register |
|tasks.subject  |TEXT  | subject of task |
|tasks.description  |TEXT  | description of task |
|tasks.state  |TINYINT(5)  | state of task (ex. 1: open, 2: doing, 3: done, 4: pending, 5: close) |
|tasks.priority  |TINYINT(5)  | priority of task (ex. 1: low, 2: middle, 3:high) |
|tasks.label  |TINYINT(5)  | label of task (ex. 1: bugfix, 2: support, 3: research, 4: implement, 5: other) |
|maintenances.id  |INT(11)  | ID of each maintenance |
|maintenances.start_at  | DATETIME  | maintenance started date time |
|maintenances.end_at  |DATETIME  | maintenance ended date time  |
|created_at  |DATETIME  | records creation date time |
|updated_at  |DATETIME  | last updated date time  |

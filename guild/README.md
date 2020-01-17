# **Guild of task management application**

## **Database design**
### ER 
![db_architecture](https://user-images.githubusercontent.com/59679715/72590289-b7a5ad80-3940-11ea-8f55-ae167d1d198e.png)
### Table details
|table name  | engine  | description|
|---|---|---|
| user | InnoDB | User information |
| login | InnoDB | Login information |
| task | InnoDB | Task information |
| maintenance | InnoDB | Maintenance information |

### Column details
|column name  |data type  | description|
|---|---|---|
|user.id  |BIGINT(20)  | users ID  |
|user.name  |VARCHAR(45)  | users name  |
|user.authority  |TINYINT(5)  | authority state (es. 1: normal, 2: admin) |
|login.id |BIGINT  | ID of login table|
|login.user_id  |BIGINT(20)  | users ID  |
|login.email  |VARCHAR(45)  |  email address used by login |
|login.password_digest  |VARCHAR(255)  | password used by login (irreversible) |
|task.id |BIGINT  | ID of each tasks  |
|task.user_id  |BIGINT(20)  | user_id of register |
|task.subject  |TEXT  | subject of task |
|task.description  |TEXT  | description of task |
|task.state  |TINYINT(5)  | state of task (ex. 1: open, 2: doing, 3: done, 4: pending, 5: close) |
|task.priority  |TINYINT(5)  | priority of task (ex. 1: low, 2: middle, 3:high) |
|task.label  |TINYINT(5)  | label of task (ex. 1: bugfix, 2: support, 3: research, 4: implement, 5: other) |
|maintenance.id  |INT(11)  | ID of each maintenance |
|maintenance.start_at  | DATETIME  | maintenance started date time |
|maintenance.end_at  |DATETIME  | maintenance ended date time  |
|created_at  |DATETIME  | records creation date time |
|updated_at  |DATETIME  | last updated date time  |

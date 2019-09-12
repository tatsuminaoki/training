## Architecture

### Screen Design
![gamen](dongheetodo_画面設計.jpg)

### Database Design

- USERS

column_name | data_type | primary | is_nullable | default | foreign_key | extra | comment
------------|-----------|:---------:|-------------|---------|--------|------|----|
ID        | VARCHAR(18) | ◯ | NOT NULL |   |  | |マルチバイト文字列
PASSWORD       | VARCHAR(255) | | NOT NULL |   |  |  |
EMAIL        | VARCHAR(255) | | NOT NULL |   |  | | ex) donghee_kim@fablic.co.jp
CREATED_AT        | DATETIME |  | NOT NULL |   |  | | 
UPDATED_AT        | DATETIME |  | NOT NULL |   |  | | 

- TASKS

column_name | data_type | primary | is_nullable | default | foreign_key | extra | comment
------------|-----------|:---------:|-------------|---------|--------|------|----|
ID        | INT | ◯ | NOT NULL |   |  | AUTO_INCREMENT | 
USER_ID | VARCHAR(18) | | NOT NULL | | USERS.ID | | |
NAME        | VARCHAR(255) |  | NOT NULL |   |  | | ex) iPhone11を買う
DESCRIPTION        | TEXT |  |  |   |  | |
PRIORITY        | TINYINT |  | NOT NULL |   |  | | 1: 低 2: 中 3: 高
STATUS        | TINYINT |  | NOT NULL |   |  | | 1: 未着手 2: 着手 3: 完了
DUEDATE        | DATETIME |  |  |   |  | | ex) 2019.09.12
LABEL        | VARCHAR(50) |  |  |   |  | | ex) 
CREATED_AT        | DATETIME |  | NOT NULL |   |  | | 
UPDATED_AT        | DATETIME |  | NOT NULL |   |  | | 

- TASK_LABELS

column_name | data_type | primary | is_nullable | default | foreign_key | extra | comment
------------|-----------|:---------:|-------------|---------|--------|------|----|
ID        | INT | ◯ | NOT NULL |   |  | AUTO_INCREMENT | 
TASK_ID | INT | | NOT NULL | | TASKS.ID | | |
USER_ID | VARCHAR(18) | | NOT NULL | | USERS.ID | | |
NAME        | VARCHAR(255) |  | NOT NULL |   |  | | ex) 買い物
CREATED_AT        | DATETIME |  | NOT NULL |   |  | | 

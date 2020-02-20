## TMS

This is TMS(Task Management System), it's also created for rails training of rakuma team

* Ruby version
2.6.5

* Rails version
6.0.2.1

* Database
Mysql2
5.7.29

## アプリケーションスケッチ(基本、Trelloをベンチマーキング)
- タスク一覧ページ
![Indexpage](https://user-images.githubusercontent.com/18366817/74700095-ee275e80-5245-11ea-8db0-4a3854fe0393.jpg)

- タスク詳細管理ページ
![showDetailTask](https://user-images.githubusercontent.com/18366817/74700124-07300f80-5246-11ea-86fa-7903b050d241.jpg)

- ログインページ
![loginpage](https://user-images.githubusercontent.com/18366817/74700155-14e59500-5246-11ea-8355-119743c6c9a3.jpg)

- ユーザー登録ページ
![Registeruser](https://user-images.githubusercontent.com/18366817/74700174-2038c080-5246-11ea-8a9a-87abcfae025d.jpg)

## DB設計

- UML DB
![UMLDB](https://user-images.githubusercontent.com/18366817/74795370-1af07a00-5309-11ea-863f-e68357f46627.jpg)



- DB詳細情報
```
DROP TABLE IF EXISTS TASKS;
DROP TABLE IF EXISTS LABELS;
DROP TABLE IF EXISTS EVENTS;
DROP TABLE IF EXISTS USERS_PROJECTS;
DROP TABLE IF EXISTS USERS;
DROP TABLE IF EXISTS PROJECTS;

-- create users table
CREATE TABLE USERS(
  id INT NOT NULL AUTO_INCREMENT,
  nickname VARCHAR(255) NOT NULL,
  email VARCHAR(255) NOT NULL,
  encrypted_password VARCHAR(255) NOT NULL,
  created_at DATETIME NOT NULL,
  updated_at DATETIME NOT NULL,
  PRIMARY KEY (id),
  UNIQUE(id),
  UNIQUE(email)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- create projects table
CREATE TABLE PROJECTS(
  id INT NOT NULL AUTO_INCREMENT,
  name VARCHAR(255) NOT NULL,
  created_at DATETIME NOT NULL,
  updated_at DATETIME NOT NULL,
  PRIMARY KEY (id),
  UNIQUE(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE INDEX projects_name_idx ON PROJECTS (name);

-- create user_projects table, this table is midlle table
CREATE TABLE USERS_PROJECTS(
  user_id INT NOT NULL,
  project_id INT NOT NULL,
  created_at DATETIME NOT NULL,
  updated_at DATETIME NOT NULL,
  PRIMARY KEY (user_id, project_id),
  FOREIGN KEY (project_id) REFERENCES PROJECTS(id) ON DELETE CASCADE,
  FOREIGN KEY (user_id) REFERENCES USERS(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8; 

-- create EVENTS table
CREATE TABLE EVENTS(
  id INT NOT NULL AUTO_INCREMENT,
  name VARCHAR(255) NOT NULL,
  sort_number INT NOT NULL, -- 画面でEVENTSの表示順番を決める
  project_id INT NOT NULL,
  created_at DATETIME NOT NULL,
  updated_at DATETIME NOT NULL,
  PRIMARY KEY (id),
  UNIQUE(id),
  FOREIGN KEY (project_id) REFERENCES PROJECTS (id) ON DELETE RESTRICT ON UPDATE CASCADE
)ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- create label table
CREATE TABLE LABELS(
  id INT NOT NULL AUTO_INCREMENT,
  name VARCHAR(255) NOT NULL,
  project_id INT NOT NULL,
  created_at DATETIME NOT NULL,
  updated_at DATETIME NOT NULL,
  PRIMARY KEY (id),
  UNIQUE(id),
  FOREIGN KEY (project_id) REFERENCES PROJECTS (id) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- create tasks table
CREATE TABLE TASKS(
  id INT NOT NULL AUTO_INCREMENT,
  name VARCHAR(255) NOT NULL,
  priority CHAR(10) NOT NULL, -- Maganement as ENUM(HIGH, MEDIUM, LOW)
  end_period_at DATETIME NULL,
  event_id INT NOT NULL,
  creator_name VARCHAR(255) NULL,
  assignee_name VARCHAR(255) NULL,
  label_id INT NULL,
  description TEXT NULL,
  created_at DATETIME NOT NULL,
  updated_at DATETIME NOT NULL,
  PRIMARY KEY (id),
  UNIQUE(id),
  FOREIGN KEY (event_id) REFERENCES EVENTS (id) ON DELETE RESTRICT ON UPDATE CASCADE,
  FOREIGN KEY (label_id) REFERENCES LABELS (id) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
```

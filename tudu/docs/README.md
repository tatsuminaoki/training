### アプリケーションのイメージ (画面)

![アプリケーションのイメージ](/tudu/docs/screen.png)

### モデルのイメージ

![モデルのイメージ](/tudu/docs/simple-model.png)

### モデル定義

今回 ```PRIMARY KEY``` ```UNIQUE KEY``` 以外のインデックスについては考えません

#### ユーザー (user)

password_digest Railsのログイン機構を利用予定です

|カラム名|データ型|
|:--:|:--:|
|id|int|
|email|varchar(100)|
|digest_password|varchar(255)|
|created_at|datetime|
|updated_at|datetime|


#### タスク (task)

|カラム名|データ型|
|:--:|:--:|
|id|int|
|user_id|int|
|name|varchar(50)|
|content|text|
|priority|smallint|
|expire_date|DATE|
|status|tinyint|
|label|varchar(20)|
|created_at|datetime|
|updated_at|datetime|

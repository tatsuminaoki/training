### アプリケーションのイメージ (画面)

![アプリケーションのイメージ](/tudu/docs/screen.png)

### モデルのイメージ

![モデルのイメージ](/tudu/docs/simple-model.png)

### モデル定義

今回 ```PRIMARY KEY``` ```UNIQUE KEY``` 以外のインデックスについては考えません

#### ユーザー (user)

password_digest Railsのログイン機構を利用予定です

|論理名|カラム名|データ型|null制約|
|:--:|:--:|:--:|:--:|
|ID|id|int|not null|
|メールアドレス|email|varchar(100)|not null|
|ダイジェストパスワード|digest_password|varchar(255)|not null|
|作成日時|created_at|datetime|not null|
|更新日時|updated_at|datetime|not null|

#### 主キー

- id

#### ユニークキー

- email


#### タスク (task)

|論理名|カラム名|データ型|null制約|ex)|
|:--:|:--:|:--:|:--:|:--:|
|ID|id|int|not null||
|ユーザーID|user_id|int|not null||
|タスク名|name|varchar(50)|not null|お買い物|
|タスク内容|content|text|not null|牛乳(1リットル)を1つ買う|
|優先順位|priority|smallint|null|2|
|期限|expire_date|DATE|null|2019/04/09|
|ステータス|status|tinyint|not null|3 (1: 未着手, 2: 着手, 3: 完了)|
|ラベル|label|varchar(20)|not null||
|作成日時|created_at|datetime|not null||
|更新日時|updated_at|datetime|not null||

#### 主キー

- id

#### 外部キー

- user_id

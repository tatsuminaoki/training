# training

## システム要件 設計のチェックシート
- [x] 自分のタスクを簡単に登録したい
登録画面プロトタイプ（済)
タスク一覧テーブル(済)

- [x] タスクに終了期限を設定できるようにしたい
 タスク一覧テーブルにdeadlineカラムを追加(済)


- [x] タスクに優先順位をつけたい
 タスク一覧テーブルにpriorityカラムを追加(済)


- [x] ステータス（未着手・着手・完了）を管理したい
 タスク一覧テーブルにstatusカラムを追加(済)


- [x] ステータスでタスクを絞り込みたい
 一覧画面プロトタイプ（済)
 タスク一覧テーブルにstatusカラムを追加(済)


- [x] タスク名・タスクの説明文でタスクを検索したい
 一覧画面プロトタイプ（済)


- [x] タスクを一覧したい。一覧画面で（優先順位、終了期限などを元にして）ソートしたい
 一覧画面プロトタイプ（済)


- [x] タスクにラベルなどをつけて分類したい
一覧画面プロトタイプ (済)


- [x] ユーザ登録し、自分が登録したタスクだけを見られるようにしたい
タスク一覧テーブルにユーザIDを入れた。


## プロトタイプ

プロトタイプと画面
![プロトタイプ](prototype.jpg "プロトタイプ")

## テーブル構成

### user table (ユーザテーブル)

| column name | カラム型 | プライマリキー | NULL | DEFALUT| 説明 |
|:-----------|:------------:|:------------:|:------------:|:------------:|:------------|
| id | INT | ○ | | |ユーザID|
| mail | VARCHAR(255) | | | |メールアドレス (uniq)|
| user_name | VARCHAR(255) | | | |ユーザ名|
| encrypted_password | VARCHAR(255)  | | | |暗号化されたパスワード|

index
~~- mail, encrypted_password~~
~~メール、パスワード認証用~~

黒田さんコメント参考
```
確かにカーディナリティ高いのですが、今後のステップでログイン周りの実装するときに
メールアドレスで検索してレコード引いてから、パスワードの照合する流れになると思うので使わないと思います
```

### task table (タスク一覧のテーブル)

| column name | カラム型 | プライマリキー | NULL | DEFALUT | 説明 |
|:-----------|:------------:|:------------:|:------------:|:------------|:------------|
| id | INT | ○ | | | タスクID |
| task_name | VARCHAR(255) | | | | タスク名 |
| description | TEXT | | | | タスク詳細内容 |
| user_id | INT | | | | user_id |
| deadline | DATE | | ○ | NULL | 終了期限日 |
| priority | TINY INT |  | | | 優先度 (低：0, 中:1, 高:2) |
| status | TINY INT | | | 0 |ステータス (未着手:0, 着手:1, 完了: 2) | 

index
- user_id
一覧でログインしたuser_idのタスクを表示するため

~~- user_id, task_name~~
~~タスク名で検索するため~~　(task_nameはlike検索なので、index貼っても意味ない？)

~~- user_id, priority~~
~~優先順位でソートするため~~

~~- user_id, deadline~~
~~終了期限でソートするため~~

~~- user_id, status~~
~~statusで検索するため~~

### master label table (ラベル管理テーブル)
| column name | カラム型 | プライマリキー | NULL | DEFALUT | 説明 |
|:-----------|:------------:|:------------:|:------------:|:------------|:------------|
| id | INT | ○ | | | master_label_id |
| label_name | varchar(100) | | | | ラベル名 (uniq) |

## task label manage table (タスク一覧で保持するラベルテーブル)

| column name | カラム型 | プライマリキー | NULL | DEFALUT | 説明 |
|:-----------|:------------:|:------------:|:------------:|:------------|:------------|
| id | INT | ○ | | | タスクで管理するラベルID |
| task_id | INT | | | | タスクID ※ multi(task_id, label_idでユニーク) |
| label_id | INT | | | | master label tableのlabel_id |

index
- task_id
一覧表示画面でtaskテーブルと結合するため

- task_id, label_id
一覧表示画面でラベル検索するため


## STEP 5

### ステップ5: データベースの接続設定（周辺設定）をしましょう

- [X] まずGitで新たにトピックブランチを切りましょう
  - 以降、トピックブランチ上で作業をしてコミットをしていきます
  
- [X] Bundlerをインストールしましょう
-  [X]  `Gemfile` で `mysql2` （MySQLのデータベースドライバ）をインストールしましょう
-  [ ]  `database.yml` の設定をしましょう
-  [ ]  `rails db:create` コマンドでデータベースの作成をしましょう
-  [ ]  `rails db` コマンドでデータベースへの接続確認をしましょう
-  [ ] GitHub上でPRを作成してレビューしてもらいましょう
  - コメントがついたらその対応を行ってください。LGTM（Looks Good To Me）が2つついたらmasterブランチにマージしましょう

### Bundlerってなに？
https://qiita.com/oshou/items/6283c2315dc7dd244aef

npmとかyurnみたいにgemのライブラリのバージョン管理してくれるもの
既にインストール済み

```
$ bundler -v 
Bundler version 1.16.6
```

### `Gemfile` で `mysql2` （MySQLのデータベースドライバ）をインストールしましょうってなに？
bundle使ってGemfileにリスト化したgemを一括でインストールできる

mysql2のバージョン確認
```
 gem list mysql2 --remote
 
 mysql2 (0.5.2 ruby x64-mingw32 x86-mingw32 x86-mswin32-60)
```

:require => false
https://teratail.com/questions/88151
```
Bundler.requireを使うと、個別にrequire 'hoge'を書かなくても、Gemfileに書かれたgemを一括でrequireすることができます。このとき、:require => falseが指定されたgemは対象から除外されます。
```

Gemfileの修正箇所

- Gemfileからsqlite3の記述を削除、代わりにmysql2の記述を追記

一括インストール
```
$ bundle install --path vendor/bundle
```

Railsアプリにインストールされているgem一覧を見る方法
```
$ bundle list 
```

### database.ymlの書き換え
参考
https://qiita.com/shi-ma-da/items/caac6a0b40bbaddd9a6f
- adapter: sqlite -> mysql2へ変更

### rails db:createcommandでデータベース作成
```
$ rails db:create
Created database 'hajimeaiizuka_task_manager_develop'
Created database 'hajimeaiizuka_task_manager_test'
```

### rails dbコマンドで接続確認
```
$ rails db
Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 33
Server version: 5.6.41 Homebrew

Copyright (c) 2000, 2018, Oracle and/or its affiliates. All rights reserved.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

mysql> show databases;
+------------------------------------+
| Database                           |
+------------------------------------+
| information_schema                 |
| fril                               |
| fril_test                          |
| hajimeaiizuka_task_manager_develop |
| hajimeaiizuka_task_manager_test    |
| mysql                              |
| performance_schema                 |
| test                               |
+------------------------------------+
8 rows in set (0.00 sec)
```

## STEP6

### `rails generate` コマンドでタスクのCRUDに必要なモデルクラスを作成しましょう

```
rails generate model user mail:string:uniq user_name:string encrypted_password:string
rails generate model task task_name:string description:text user_id:integer:index deadline:date priority:integer status:integer
rails generate model label label_name:string:uniq
rails generate model task_label task_id:integer:index label_id:integer
```

- マイグレーションを作成し、これを用いてテーブルを作成しましょう
  - マイグレーションは1つ前の状態に戻せることを担保できていることが大切です！ `redo` を流して確認する癖をつけましょう

```
rails db:migrate
```

db/migrate/...の中身を修正

versionの確認

```
$ rails db:migrate:status
```

redoでテーブル構成修正
```
$ rails db:migrate:redo VERSION=20181010024132
```

### 複合indexの作り方

参考
https://qiita.com/zaru/items/cde2c46b6126867a1a64
```
$ rails g migration AddIndexTaskLabel
Running via Spring preloader in process 62911
      invoke  active_record
      create    db/migrate/20181010090931_add_index_task_label.rb
```

migrationファイルの修正
```
class AddIndexTaskLabel < ActiveRecord::Migration[5.2]
  def change
    add_index :task_labels, [:task_id, :label_id], :name => 'unique_task_label', :unique => true
  end
end
```

```
$ rails db:migrate
== 20181010090931 AddIndexTaskLabel: migrating ================================
-- add_index(:task_labels, [:task_id, :label_id], {:name=>"unique_task_label", :unique=>true})
   -> 0.0119s
== 20181010090931 AddIndexTaskLabel: migrated (0.0120s) =======================
```

確認
```
show create table task_labels;
UNIQUE KEY `unique_task_label` (`task_id`,`label_id`),

```

- `rails c` コマンドでモデル経由でデータベースに接続できることを確認しましょう
  - この時に試しにActiveRecordでレコードを作成してみる

```
$ rails c
Running via Spring preloader in process 63853
Loading development environment (Rails 5.2.1)
irb(main):001:0> user = User.new
   (0.3ms)  SET NAMES utf8,  @@SESSION.sql_mode = CONCAT(CONCAT(@@sql_mode, ',STRICT_ALL_TABLES'), ',NO_AUTO_VALUE_ON_ZERO'),  @@SESSION.sql_auto_is_null = 0, @@SESSION.wait_timeout = 2147483
=> #<User id: nil, mail: nil, user_name: nil, encrypted_password: nil, created_at: nil, updated_at: nil>
irb(main):002:0> user.attributes = {mail: "hajime_iizuka@fablic.co.jp", user_name: "飯塚 一", encrypted_password: "fdasfsafdsafsafdsa"}
=> {:mail=>"hajime_iizuka@fablic.co.jp", :user_name=>"飯塚 一", :encrypted_password=>"fdasfsafdsafsafdsa"}
irb(main):003:0> user.save
   (0.2ms)  BEGIN
  User Create (0.3ms)  INSERT INTO `users` (`mail`, `user_name`, `encrypted_password`, `created_at`, `updated_at`) VALUES ('hajime_iizuka@fablic.co.jp', '飯塚 一', 'fdaafdsafsafdsa', '2018-10-10 09:18:43', '2018-10-10 09:18:43')
   (1.8ms)  COMMIT
=> true
```

```
mysql> select * from users;
+----+----------------------------+------------+--------------------+---------------------+---------------------+
| id | mail                       | user_name  | encrypted_password | created_at          | updated_at          |
+----+----------------------------+------------+--------------------+---------------------+---------------------+
|  1 | hajime_iizuka@fablic.co.jp | 飯塚 一    | fdasfsafdsafsafdsa | 2018-10-10 09:18:43 | 2018-10-10 09:18:43 |
+----+----------------------------+------------+--------------------+---------------------+---------------------+
1 row in set (0.00 sec)
```
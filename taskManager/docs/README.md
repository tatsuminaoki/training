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


存在しないユーザでのタスクレコード追加は失敗する
```
irb(main):018:0> task3 = Task.new
=> #<Task id: nil, task_name: nil, description: nil, user_id: nil, deadline: nil, priority: nil, status: 0, created_at: nil, updated_at: nil>
irb(main):019:0> task3.attributes = { task_name: "瞑想をする", description: "落ち着くために瞑想をする", user_id: 4, priority: 0}
=> {:task_name=>"瞑想をする", :description=>"落ち着くために瞑想をする", :user_id=>4, :priority=>0}
irb(main):020:0> task3.save
   (0.2ms)  BEGIN
  User Load (0.2ms)  SELECT  `users`.* FROM `users` WHERE `users`.`id` = 4 LIMIT 1
   (0.1ms)  ROLLBACK
=> false
```

存在するラベル、タスクでタスクラベルレコード追加は成功
```
irb(main):012:0> taskLabel = TaskLabel.new
=> #<TaskLabel id: nil, task_id: nil, label_id: nil, created_at: nil, updated_at: nil>
irb(main):013:0> taskLabel.attributes = {task_id: 2, label_id: 1}
=> {:task_id=>2, :label_id=>1}
irb(main):014:0> taskLabel.save
   (0.2ms)  BEGIN
  Task Load (0.3ms)  SELECT  `tasks`.* FROM `tasks` WHERE `tasks`.`id` = 2 LIMIT 1
  Label Load (0.3ms)  SELECT  `labels`.* FROM `labels` WHERE `labels`.`id` = 1 LIMIT 1
  TaskLabel Create (0.2ms)  INSERT INTO `task_labels` (`task_id`, `label_id`, `created_at`, `updated_at`) VALUES (2, 1, '2018-10-11 00:14:58', '2018-10-11 00:14:58')
   (0.8ms)  COMMIT
=> true
```

存在しないラベル、存在するタスクでタスクラベルレコード追加は失敗
```
irb(main):001:0> taskLabel = TaskLabel.new
   (0.3ms)  SET NAMES utf8,  @@SESSION.sql_mode = CONCAT(CONCAT(@@sql_mode, ',STRICT_ALL_TABLES'), ',NO_AUTO_VALUE_ON_ZERO'),  @@SESSION.sql_auto_is_null = 0, @@SESSION.wait_timeout = 2147483
=> #<TaskLabel id: nil, task_id: nil, label_id: nil, created_at: nil, updated_at: nil>
irb(main):002:0> taskLabel.attributes = {task_id: 2, label_id: 2}
=> {:task_id=>2, :label_id=>2}
irb(main):003:0> taskLavel.save
Traceback (most recent call last):
        1: from (irb):3
NameError (undefined local variable or method `taskLavel' for main:Object)
Did you mean?  taskLabel
irb(main):004:0> taskLabel.save
   (0.2ms)  BEGIN
  Task Load (0.3ms)  SELECT  `tasks`.* FROM `tasks` WHERE `tasks`.`id` = 2 LIMIT 1
  Label Load (0.3ms)  SELECT  `labels`.* FROM `labels` WHERE `labels`.`id` = 2 LIMIT 1
   (0.4ms)  ROLLBACK
=> false
```

存在するラベル、存在しないタスクでタスクラベルレコード追加は失敗
```
$ rails c
Running via Spring preloader in process 79721
Loading development environment (Rails 5.2.1)
irb(main):001:0> taskLabel = TaskLabel.new
   (0.5ms)  SET NAMES utf8,  @@SESSION.sql_mode = CONCAT(CONCAT(@@sql_mode, ',STRICT_ALL_TABLES'), ',NO_AUTO_VALUE_ON_ZERO'),  @@SESSION.sql_auto_is_null = 0, @@SESSION.wait_timeout = 2147483
=> #<TaskLabel id: nil, task_id: nil, label_id: nil, created_at: nil, updated_at: nil>
irb(main):002:0> taskLabel.attributes = {task_id: 3, label_id: 5}
=> {:task_id=>3, :label_id=>5}
irb(main):003:0> taskLabel.save
   (0.2ms)  BEGIN
  Task Load (0.3ms)  SELECT  `tasks`.* FROM `tasks` WHERE `tasks`.`id` = 3 LIMIT 1
  Label Load (0.2ms)  SELECT  `labels`.* FROM `labels` WHERE `labels`.`id` = 5 LIMIT 1
   (0.2ms)  ROLLBACK
=> false
```

ユーザを消すとタスク、タスクラベルが削除されるか? (hajime.a.iizuka@rakuten.comを削除)
```
mysql> select * from users;
+----+-----------------------------+--------------+--------------------+---------------------+---------------------+
| id | mail                        | user_name    | encrypted_password | created_at          | updated_at          |
+----+-----------------------------+--------------+--------------------+---------------------+---------------------+
|  1 | hajime_iizuka@fablic.co.jp  | 飯塚 一      | fdasfsafdsafsafdsa | 2018-10-10 23:50:44 | 2018-10-10 23:50:44 |
|  2 | hajime.a.iizuka@rakuten.com | 楽天飯塚     | dfafdafdafdsafdsaf | 2018-10-11 00:30:47 | 2018-10-11 00:30:47 |
+----+-----------------------------+--------------+--------------------+---------------------+---------------------+
2 rows in set (0.00 sec)

mysql> select * from tasks;
+----+--------------------------+--------------------------------------------+---------+----------+----------+--------+---------------------+---------------------+
| id | task_name                | description                                | user_id | deadline | priority | status | created_at          | updated_at          |
+----+--------------------------+--------------------------------------------+---------+----------+----------+--------+---------------------+---------------------+
|  1 | 瞑想をする               | 落ち着くために瞑想をする                   |       1 | NULL     |        0 |      0 | 2018-10-10 23:55:54 | 2018-10-10 23:57:32 |
|  2 | 本を読む                 | 頑張って本を読む                           |       1 | NULL     |        0 |      0 | 2018-10-10 23:58:55 | 2018-10-10 23:58:55 |
|  3 | 朝ランニングする         | できるかわからんけど朝走るよ               |       2 | NULL     |        0 |      0 | 2018-10-11 00:36:49 | 2018-10-11 00:36:49 |
+----+--------------------------+--------------------------------------------+---------+----------+----------+--------+---------------------+---------------------+
3 rows in set (0.00 sec)

mysql> select * from labels;
+----+-----------------+---------------------+---------------------+
| id | label_name      | created_at          | updated_at          |
+----+-----------------+---------------------+---------------------+
|  1 | 読書            | 2018-10-11 00:06:05 | 2018-10-11 00:06:05 |
|  2 | ランニング      | 2018-10-11 00:32:43 | 2018-10-11 00:32:43 |
+----+-----------------+---------------------+---------------------+
2 rows in set (0.00 sec)


mysql> select * from task_labels;
+----+---------+----------+---------------------+---------------------+
| id | task_id | label_id | created_at          | updated_at          |
+----+---------+----------+---------------------+---------------------+
|  1 |       2 |        1 | 2018-10-11 00:14:58 | 2018-10-11 00:14:58 |
|  2 |       3 |        2 | 2018-10-11 00:39:53 | 2018-10-11 00:39:53 |
+----+---------+----------+---------------------+---------------------+
2 rows in set (0.00 sec)


$ rails c
Running via Spring preloader in process 82349
Loading development environment (Rails 5.2.1)
irb(main):001:0> user = User.find(2)
   (0.3ms)  SET NAMES utf8,  @@SESSION.sql_mode = CONCAT(CONCAT(@@sql_mode, ',STRICT_ALL_TABLES'), ',NO_AUTO_VALUE_ON_ZERO'),  @@SESSION.sql_auto_is_null = 0, @@SESSION.wait_timeout = 2147483
  User Load (0.2ms)  SELECT  `users`.* FROM `users` WHERE `users`.`id` = 2 LIMIT 1
=> #<User id: 2, mail: "hajime.a.iizuka@rakuten.com", user_name: "楽天飯塚", encrypted_password: "dfafdafdafdsafdsaf", created_at: "2018-10-11 00:30:47", updated_at: "2018-10-11 00:30:47">
irb(main):002:0> user.destroy
   (0.2ms)  BEGIN
  Task Load (0.8ms)  SELECT `tasks`.* FROM `tasks` WHERE `tasks`.`user_id` = 2
  TaskLabel Load (0.3ms)  SELECT `task_labels`.* FROM `task_labels` WHERE `task_labels`.`task_id` = 3
  TaskLabel Destroy (0.9ms)  DELETE FROM `task_labels` WHERE `task_labels`.`id` = 2
  Task Destroy (0.3ms)  DELETE FROM `tasks` WHERE `tasks`.`id` = 3
  User Destroy (0.2ms)  DELETE FROM `users` WHERE `users`.`id` = 2
   (0.7ms)  COMMIT
=> #<User id: 2, mail: "hajime.a.iizuka@rakuten.com", user_name: "楽天飯塚", encrypted_password: "dfafdafdafdsafdsaf", created_at: "2018-10-11 00:30:47", updated_at: "2018-10-11 00:30:47">

mysql> select * from users;
+----+----------------------------+------------+--------------------+---------------------+---------------------+
| id | mail                       | user_name  | encrypted_password | created_at          | updated_at          |
+----+----------------------------+------------+--------------------+---------------------+---------------------+
|  1 | hajime_iizuka@fablic.co.jp | 飯塚 一    | fdasfsafdsafsafdsa | 2018-10-10 23:50:44 | 2018-10-10 23:50:44 |
+----+----------------------------+------------+--------------------+---------------------+---------------------+
1 row in set (0.00 sec)

mysql> select * from tasks;
+----+-----------------+--------------------------------------+---------+----------+----------+--------+---------------------+---------------------+
| id | task_name       | description                          | user_id | deadline | priority | status | created_at          | updated_at          |
+----+-----------------+--------------------------------------+---------+----------+----------+--------+---------------------+---------------------+
|  1 | 瞑想をする      | 落ち着くために瞑想をする             |       1 | NULL     |        0 |      0 | 2018-10-10 23:55:54 | 2018-10-10 23:57:32 |
|  2 | 本を読む        | 頑張って本を読む                     |       1 | NULL     |        0 |      0 | 2018-10-10 23:58:55 | 2018-10-10 23:58:55 |
+----+-----------------+--------------------------------------+---------+----------+----------+--------+---------------------+---------------------+
2 rows in set (0.00 sec)

mysql> select * from task_labels;
+----+---------+----------+---------------------+---------------------+
| id | task_id | label_id | created_at          | updated_at          |
+----+---------+----------+---------------------+---------------------+
|  1 |       2 |        1 | 2018-10-11 00:14:58 | 2018-10-11 00:14:58 |
+----+---------+----------+---------------------+---------------------+
1 row in set (0.00 sec)

mysql> select * from labels;
+----+-----------------+---------------------+---------------------+
| id | label_name      | created_at          | updated_at          |
+----+-----------------+---------------------+---------------------+
|  1 | 読書            | 2018-10-11 00:06:05 | 2018-10-11 00:06:05 |
|  2 | ランニング      | 2018-10-11 00:32:43 | 2018-10-11 00:32:43 |
+----+-----------------+---------------------+---------------------+
2 rows in set (0.00 sec)
```

## STEP7 タスク一覧画面

### `rails generate` コマンドでコントローラとビューを作成します

取り消しコマンド
https://shinodogg.com/?p=3341

リスト作成
```
$ rails generate controller list index

取り消し方法    
$ rails destroy controller list

listコントローラのindexアクションを作る
$ rails generate controller list index
Running via Spring preloader in process 83725
      create  app/controllers/list_controller.rb
       route  get 'list/index'
      invoke  erb
      create    app/views/list
      create    app/views/list/index.html.erb
      invoke  test_unit
      create    test/controllers/list_controller_test.rb
      invoke  helper
      create    app/helpers/list_helper.rb
      invoke    test_unit
      invoke  assets
      invoke    coffee
      create      app/assets/javascripts/list.coffee
      invoke    scss
      create      app/assets/stylesheets/list.scss
```

登録フォーム生成時にform_forでエラーが出る。
```
undefined method `tasks_path' for #<#<Class:0x00007fe0ceb414a8>:0x00007fe0c9d35de0>
Did you mean?  asset_path
```

参考資料
https://teamtreehouse.com/community/undefined-method-error-when-using-formfor


  - コントローラとビューに必要な実装を追加しましょう
  - 作成、更新、削除後はそれぞれflashメッセージを画面に表示させましょう
- `routes.rb` を編集して、 `http://localhost:3000/` でタスクの一覧画面が表示されるようにしましょう
- GitHub上でPRを作成してレビューしてもらいましょう
  - 今後、PRが大きくなりそうだったらPRを2回以上に分けることを検討しましょう
  
 ## STEP 8
 
 ### user model作成
 ```
 $ rails g rspec:model user
 Running via Spring preloader in process 22088
       create  spec/models/user_spec.rb
 ```
 
 ### factory_botの追加
```
$ bin/rails g factory_bot:model user
Running via Spring preloader in process 22381
      create  spec/factories/users.rb

```


### STEP16
- ユーザモデルを作成してみましょう
- 最初のユーザをseedで作成してみましょう
- ユーザとタスクが紐づくようにしましょう
  - 関連に対してインデックスを貼りましょう
  - N+1問題を回避するための仕組みを取り入れましょう
  
 
### マイグレーションファイル作成
```
bin/rails generate migration EditColumnUser
```

seeds.rb投入
```
bin/rails db:seed
```


- [] 追加のGemを使わず、自分で実装してみましょう
  - [] DeviseなどのGemを使わないことで、HTTPのCookieやRailsにおけるSessionなどの仕組みについて理解を深めることが目的です
  - [] また、一般的な認証についての理解を深めることも目的にしています（パスワードの取り扱いについてなど）

- [] ログイン画面を実装しましょう
ログインしていない場合は、タスク管理のページに遷移できないようにしましょう
自分が作成したタスクだけを表示するようにしましょう
ログアウト機能を実装しましょう


### ログインコントローラ作成
rails g controller logins

### Redisの起動
brew services restart redis


## ユーザ管理

```
bin/rails g controller admin/users
```
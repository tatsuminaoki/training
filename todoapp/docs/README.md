## 画面設計

### タスク表示
![](memo_image_todo.jpg)

### 管理画面
![](memo_image_admin.jpg)

### テーブル設計

#### users：ユーザ一覧
| カラム名 | 型 | プライマリキー | NULL | DEFALUT | 説明 |
|:-----------|:------------:|:------------:|:------------:|:------------|:------------|
| id | int | ○ | | | ユーザID, UNSINGED |
| email | varchar | | | | メールアドレス, UNIQ |
| encrypted_password | varchar | | | | 暗号化済みのパスワード |
| name | varchar | | | | ユーザ名 |
| user_groups_id | int | | ○ | | ユーザのグループ INDEX, FOREIGN KEY user_groups.id |
| role | tinyint | | | | 1: 一般, 2:  管理者 |
| created_at | datetime | | | | 作成日付 |
| updated_at | datetime | | | | 更新日付 |

#### user_groups：ユーザの所属するグループ
| カラム名 | 型 | プライマリキー | NULL | DEFALUT | 説明 |
|:-----------|:------------:|:------------:|:------------:|:------------|:------------|
| id | int | ○ | | | グループID, UNSINGED |
| name | varchar | | | | グループ名 |
| created_at | datetime | | | | 作成日付 |
| updated_at | datetime | | | | 更新日付 |

#### user_tasks：ユーザの作成したタスクたち
| カラム名 | 型 | プライマリキー | NULL | DEFALUT | 説明 |
|:-----------|:------------:|:------------:|:------------:|:------------|:------------|
| id | int | ○ | | | タスクID, UNSINGED |
| users_id | int | | | | 作成したユーザID, INDEX, FOREIGN KEY users.id |
| title | varchar | | | | タスクのタイトル, INDEX |
| description | text | | ○ | | タスクの説明 |
| status | tinyint | | | | 1: 未着手、2: 着手中、3: 完了 INDEX |
| end_at | datetime | | ○ | | タスクの終了日付 |
| created_at | datetime | | | | 作成日付 |
| updated_at | datetime | | | | 更新日付 |

#### task_labels：タスクのラベル
| カラム名 | 型 | プライマリキー | NULL | DEFALUT | 説明 |
|:-----------|:------------:|:------------:|:------------:|:------------|:------------|
| id | int | ○ | | | ラベルID, UNSINGED |
| name | varchar | | | | ラベル名 |
| created_at | datetime | | | | 作成日付 |
| updated_at | datetime | | | | 更新日付 |

#### user_task_labels：ユーザの作成したタスクとラベルの紐づけ
| カラム名 | 型 | プライマリキー | NULL | DEFALUT | 説明 |
|:-----------|:------------:|:------------:|:------------:|:------------|:------------|
| id | int | ○ | | | ID, UNSINGED |
| users_id | int | | | | 作成したユーザID, INDEX, FOREIGN KEY users.id |
| task_labels_id | int | ○ | | | FOREIGN KEY task_labels.id |
| user_tasks_id | int | ○ | | | FOREIGN KEY user_tasks.id |


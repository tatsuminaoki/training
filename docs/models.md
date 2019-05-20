①ユーザー (User / users)
--------
項目名 | column  | type  | null | default | key |  uniq | describe
--- | --- | --- | --- | ---  | ---  | ---  | --- 
メールアドレス | email | string | false | - | - | ○ | 
名前 | name | string | false | - | - | - | 
ユーザータイプ | type | tinyint | false | - | - | - | ※ enum <br> 1: 'admin' <br> 2: 'normal'
パスワード | password | string | false | - | - | - | 
作成日 | created_at | datetime | false | - | - | - | 
更新日 | updated_at | datetime | false | - | - | - | 

②タスク (Task / tasks)
--------
項目名 | column  | type  | null | default | key |  uniq | describe
--- | --- | --- | --- | ---  | ---  | ---  | --- 
ユーザーID | user_id | integer | false | - | - | ○ | 
名前 | name | string | false | - | - | - | 
ステータス | status | tinyint | false | - | - | - | ※ enum <br> 1: 'waiting' <br> 2: 'work_in_progress' <br> 3: 'completed'
作成日 | created_at | datetime | false | - | - | - | 
更新日 | updated_at | datetime | false | - | - | - | 

③ラベル (Label / labels)
--------
項目名 | column  | type  | null | default | key |  uniq | describe
--- | --- | --- | --- | ---  | ---  | ---  | --- 
名前 | name | string | false | - | - | - | 
作成日 | created_at | datetime | false | - | - | - | 
更新日 | updated_at | datetime | false | - | - | - | 

④タスクラベル (TaskLabel / task_labels)
--------
項目名 | column  | type  | null | default | key |  uniq | describe
--- | --- | --- | --- | ---  | ---  | ---  | --- 
タスクID | task_id | integer | false | - | - | ○ | 
ラベルID | label_id | integer | false | - | - | ○ | 
作成日 | created_at | datetime | false | - | - | - | 
更新日 | updated_at | datetime | false | - | - | - | 


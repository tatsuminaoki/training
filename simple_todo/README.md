# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

##Table定義
### Task
| column |remark  |type|
|:---|:---|:---|
| id | pk |int|
|title||varchar|
|desc||text|
|user_id||int|
|limit||datetime|
|priority||int|
|label_id||int|
|status|0:未着手/1:着手中/2:完了|int|
|del_flg|0:active/1:deleted|int|
|registered||datetime|
|modified||datetime|


###User
| column |remark  |type|
|:---|:---|:---|
| id | pk |int|
|email||varchar|
|name||varchar|
|password||varchar
|admin_flg|0:normaluser/1:admin|int|
|del_flg|0:active/1:deleted|int|
|registered||datetime|
|modified||datetime|

###Label
| column |remark  |type|
|:---|:---|:---|
| id | pk |int|
|name||varchar|
|del_flg|0:active/1:deleted|int|
|registered||datetime|
|modified||datetime|


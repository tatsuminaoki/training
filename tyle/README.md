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

* ...

## Step 4

### Prototype
![Prototype](https://user-images.githubusercontent.com/56104871/66620951-596c7e80-ec1d-11e9-8a3f-276b27e3a12f.JPG)
- middle left-hand side -> login page
- upper left-hand side -> home (task list) page (in which you can see and search tasks)
- upper right-hand side -> task create page
- middle right-hand side -> task detail page (in which you can see the tasks)
- bottom left-hand side -> task edit page
- bottom right-hand side -> task delete page


### Database Schema

![ER](https://user-images.githubusercontent.com/56104871/66620962-638e7d00-ec1d-11e9-954e-db37cbe2de77.jpg)

## Step 6

```
#!/bin/bash
# user
# rails generate model user name:string login_id:string password:digest deleted_at:datetime
rails db:migrate
rails db:migrate:redo

# task
# rails generate model task name:string description:text user:references priority:integer status:integer due:datetime deleted_at:datetime
rails db:migrate
rails db:migrate:redo

# label
# rails generate model label name:string
rails db:migrate
rails db:migrate:redo

# task_label
# rails generate model task_label task:references label:references
rails db:migrate
rails db:migrate:redo
```

## Step 7

```
#!/bin/bash
# rails generate controller tasks index new create show edit update destroy
```

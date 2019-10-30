# training

## information
- See tyle/README.md for the prototype and the database schema.

## how to start TYLE
```
# MySQL
$ cd tyle/development/mysql
$ export RAILS_DATABASE_PASSWORD=my_root_password
$ echo MYSQL_ROOT_PASSWORD=$RAILS_DATABASE_PASSWORD > .env
$ docker-compose up -d

# Rails
$ cd tyle
$ rails db:create
$ rails db:migrate
$ rails db:seed
$ RAILS_ENV=development bundle exec rails s

# Rspec
$ cd tyle
$ rails db:migrate RAILS_ENV=test
$ bundle exec rspec
```

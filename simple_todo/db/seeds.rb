# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
User.create(:email => 'sangjin.oh@rakuten.com', :name => 'Sangjin oh', :password => '1234', :admin_flag => 1)
User.create(:email => 'test1@test.com', :name => 'test1', :password => '1234', :admin_flag => 0)
User.create(:email => 'test2@test.com', :name => 'test2', :password => '1234', :admin_flag => 1)
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

require 'active_record'
require 'activerecord-import'

last_insert_user_id = User.maximum(:id) || 0

userobj = {
  password: 'abc',
  name: 'おなまえ',
  group_id: nil,
  role: 1
}

taskobj = {
  title: 'たすくだよ',
  description: 'たすくだよー',
  status: 1
}

# add users
users = []
tasks = []
10.times do |i|
  last_insert_user_id += 1
  users << User.new(userobj.merge(id: last_insert_user_id, email: "aaaa#{i}@gmail.com"))
  10.times do |_i|
    tasks << Task.new(taskobj.merge(user_id: last_insert_user_id))
  end
end
User.import users
Task.import tasks

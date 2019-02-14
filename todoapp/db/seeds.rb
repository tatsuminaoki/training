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
last_insert_task_id = Task.maximum(:id) || 0
last_insert_label_id = Label.maximum(:id) || 0

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

label_names = %i(
  重要
  重要ではない
  重要かもしれない
  重要だと思う
  重要な可能性がある
  重要だと信じたい
  重要だったらいいなあ
  重要な気がした
  重要だった
  重要っていいな
)

# add users
users = []
tasks = []
labels = []
task_labels = []
10.times do |i|
  last_insert_user_id += 1
  users << User.new(userobj.merge(id: last_insert_user_id, email: "aaaa#{i}@gmail.com"))
  10.times do |_i|
    last_insert_task_id += 1
    tasks << Task.new(taskobj.merge(id: last_insert_task_id, user_id: last_insert_user_id))

    last_insert_label_id += 1
    labels << Label.new({
      id: last_insert_label_id,
      user_id: last_insert_user_id,
      name: label_names[_i]
    })

    task_labels << TaskLabel.new({
      label_user_id: last_insert_user_id,
      task_id: last_insert_task_id,
      label_id: last_insert_label_id
    })
  end
end
User.import users
Task.import tasks
Label.import labels
TaskLabel.import task_labels

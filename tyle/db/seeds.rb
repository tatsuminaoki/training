# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
User.create(name: 'user1', login_id: 'id1', password: 'password1')
(1..100).each do |i|
  Task.create(name: "task#{i}", description: "this is a task#{i}", user_id: 1, priority: i % 3, status: i % 3, due: "2021010#{i % 10}")
end

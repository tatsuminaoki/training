# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
(1..3).each do |j|
  User.create(name: "user#{j}", login_id: "id#{j}", password: "password#{j}", role: j % 2)
  (1..100).each do |i|
    Task.create(name: "task#{i}", description: "this is a task#{i}", user_id: j, priority: i % 3, status: i % 3, due: "2021010#{i % 10}")
  end
end

(1..7).each do |i|
  Label.create(name: "label#{i}")
end

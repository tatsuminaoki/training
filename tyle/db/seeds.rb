# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
User.create(name: 'user1', login_id: 'id1', password_digest: 'password1')
Task.create(name: 'task1', description: 'this is a task1', user_id: 1, priority: 1, status: 1, due_at: '20201231')

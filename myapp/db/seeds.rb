# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

user1 = User.create(name: 'name1', account: 'account1', password: 'pass')
user2 = User.create(name: 'name2', account: 'account2', password: 'pass')
user3 = User.create(name: 'name3', account: 'account3', password: 'pass')

5.times do |index|
  user1.tasks.create(name: "#{user1.name}-task#{index}")
  user2.tasks.create(name: "#{user2.name}-task#{index}")
  user3.tasks.create(name: "#{user3.name}-task#{index}")
end

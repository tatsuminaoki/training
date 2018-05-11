# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
require 'digest/md5'

5.times do |no|
  login_id = "tmr#{no}"
  User.create(login_id: login_id, password_hash: User.password_hash(login_id, login_id))
end

User.create(login_id: 'admin', password_hash: User.password_hash('admin', 'admin'))

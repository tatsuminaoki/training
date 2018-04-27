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
  salt = login_id[login_id.length - 1]
  User.create(login_id: login_id, password_hash: Digest::SHA1.hexdigest(login_id + salt).to_s)
end

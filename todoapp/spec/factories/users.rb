FactoryBot.define do
  factory :user do
    email { 'aaaa@gmail.com' }
    password_digest { BCrypt::Password.create('abc') }
    name { 'テストユーザー' }
    group_id { nil }
    role { 1 }
  end
end

FactoryBot.define do
  factory :user do
    email { 'aaaa@gmail.com' }
    password { 'abc' }
    name { 'テストユーザー' }
    group_id { nil }
    role { 1 }
  end
end

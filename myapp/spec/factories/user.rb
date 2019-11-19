FactoryBot.define do
  sequence :email do |i|
    "hoge#{i}@example.com"
  end

  factory :user do
    name { 'hogehoge' }
    email { generate :email }
    password { 'hoge123' }
    role { :general }
  end
  factory :admin_user, class: User do
    name { 'admin_hoge' }
    email { 'fuga@example.com' }
    password { 'fuga123' }
    role { :admin }
  end
end

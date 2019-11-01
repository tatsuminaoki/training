FactoryBot.define do
  factory :user do
    name { 'hogehoge' }
    email { 'hoge@fuga.com' }
    password { 'hoge123' }
    password_confirmation { 'hoge123' }
    role { 0 }
  end
end

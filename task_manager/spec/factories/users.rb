FactoryBot.define do
  factory :user do
    name { 'test name' }
    password { 'password' }
    password_digest { 'password' }
  end
end

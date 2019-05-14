FactoryBot.define do
  factory :user do
    name { 'test name' }
    password { 'password' }
    password_digest { User.digest('password') }
  end
end

FactoryBot.define do
  factory :user do
    email { 'test@example.com' }
    password { 'password' }
    role { User.roles[:admin] }
  end
end

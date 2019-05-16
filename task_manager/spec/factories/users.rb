FactoryBot.define do
  factory :user, class: User do
    name { 'test name' }
    password { 'password' }
    password_digest { User.digest('password') }
  end
  factory :other_user, class: User do
    name { 'other name' }
    password { 'password' }
    password_digest { User.digest('password') }
  end
end

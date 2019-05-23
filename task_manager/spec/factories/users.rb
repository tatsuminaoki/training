FactoryBot.define do
  factory :user, class: User do
    name { 'test name' }
    role { 'general' }
    password { 'password' }
    password_digest { User.digest('password') }
  end
  factory :other_user, class: User do
    name { 'other name' }
    role { 'general' }
    password { 'password' }
    password_digest { User.digest('password') }
  end
  factory :admin_user, class: User do
    name { 'other name' }
    role { 'admin' }
    password { 'password' }
    password_digest { User.digest('password') }
  end
end

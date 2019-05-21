FactoryBot.define do
  factory :user, class: User do
    name { 'test name' }
    role { 1 } # admin
    password { 'password' }
    password_digest { User.digest('password') }
  end
  factory :other_user, class: User do
    name { 'other name' }
    role { 0 } # general
    password { 'password' }
    password_digest { User.digest('password') }
  end
end

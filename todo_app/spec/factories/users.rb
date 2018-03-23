FactoryBot.define do
  factory :user do
    name 'Test user'
    password 'foobar'
    password_confirmation 'foobar'
  end
end

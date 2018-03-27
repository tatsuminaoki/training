FactoryBot.define do
  factory :user do
    name 'test_user'
    password 'foobar'
    password_confirmation 'foobar'
  end
end

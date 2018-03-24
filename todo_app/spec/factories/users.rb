FactoryBot.define do
  factory :user do
    sequence(:name) { |n| "User #{n}" }
    password 'foobar'
    password_confirmation 'foobar'
  end
end

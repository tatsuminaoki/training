FactoryBot.define do
  factory :user do
    sequence(:id) { |n| "#{n}" }
    sequence(:name) { |n| "kyusookim#{n}" }
    sequence(:email) { |n| "email#{n}@example.com" }
    sequence(:password) { |n| "password#{n}" }
  end
end


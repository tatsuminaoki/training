FactoryBot.define do
  factory :user do
    sequence(:name) { 'kyusookim#{n}' }
    sequence(:email) { 'email#{n}@example.com' }
    sequence(:password) { 'password#{n}' }
  end
end


FactoryBot.define do
  factory :user do
    sequence(:mail) { |n| "user#{n}@example.com" }
    sequence(:user_name) {|n| "user#{n}" }
    encrypted_password "dottle-nouveau-pavilion-tights-furze"
  end
end

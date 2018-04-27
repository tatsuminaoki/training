FactoryBot.define do
  factory :user do
    id 1
    sequence(:login_id) { |n| "tester#{n}" }
    # Password is same as login_id
    sequence(:password_hash) { |n| User.password_hash(login_id, login_id).to_s }
  end
end

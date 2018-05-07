FactoryBot.define do
  factory :user_attributes, class: Hash do
    id 1
    sequence(:login_id) { |n| "tester#{n}" }
    sequence(:password) { |n| "tester#{n}" }
    sequence(:password_hash) { |n| User.password_hash("tester#{n}", "tester#{n}").to_s }
    admin_flab false

    initialize_with { attributes }
  end

  factory :user do
    id 1
    sequence(:login_id) { |n| "tester#{n}" }
    # Password is same as login_id
    sequence(:password_hash) { |n| User.password_hash("tester#{n}", "tester#{n}").to_s }
  end
end

FactoryBot.define do
  factory :user_attributes, class: Hash do
    sequence(:id) { |n| n }
    sequence(:login_id) { |n| "tester#{n}" }
    sequence(:password) { |n| "tester#{n}" }
    sequence(:password_hash) { |n| User.password_hash("tester#{n}", "tester#{n}").to_s }
    admin_flag false

    initialize_with { attributes }
  end


  factory :task_user, class: User do
    id 1
    sequence(:login_id) { |n| "tester#{n}" }
    # Password is same as login_id
    sequence(:password_hash) { |n| User.password_hash("tester#{n}", "tester#{n}").to_s }
  end

  factory :user do
    sequence(:id) { |n| n }
    sequence(:login_id) { |n| "tester#{n}" }
    # Password is same as login_id
    sequence(:password_hash) { |n| User.password_hash("tester#{n}", "tester#{n}").to_s }
  end

  factory :admin, class: User do
    sequence(:id) { |n| n }
    sequence(:login_id) { |n| "admin#{n}" }
    # Password is same as login_id
    sequence(:password_hash) { |n| User.password_hash("tester#{n}", "admin#{n}").to_s }
    admin_flag true
  end
end

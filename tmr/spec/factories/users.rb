FactoryBot.define do
  factory :user do
    id 1
    sequence(:login_id) { |n| "tester#{n}" }
    sequence(:password_hash) { |n| Digest::SHA1.hexdigest(login_id + n.to_s).to_s }
  end
end

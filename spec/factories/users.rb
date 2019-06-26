FactoryBot.define do
  factory :user do
    sequence(:name) { |n| "NAME_#{n}" }
    sequence(:mail) { |n| "MAIL_#{n}" }
    sequence(:password) { |n| "PASSWORD_#{n}" }
  end
end

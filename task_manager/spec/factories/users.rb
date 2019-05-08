FactoryBot.define do
  factory :user do
    name { 'MyString' }
    password { 'password' }
    password_confirmation { 'password' }
  end
end

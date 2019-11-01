FactoryBot.define do
  factory :user do
    id { 1 }
    name { 'user1' }
    login_id { 'id1' }
    password_digest { 'password1' }
  end 
end 

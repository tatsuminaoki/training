FactoryBot.define do
  factory :admin_user, class: User do
    id { 1 }
    name { 'user1' }
    login_id { 'id1' }
    password { 'password1' }
    role { 1 }
  end 

  factory :user do
    id { 2 }
    name { 'user2' }
    login_id { 'id2' }
    password { 'password2' }
    role { 0 }
  end 
end 

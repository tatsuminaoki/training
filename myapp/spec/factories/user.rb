FactoryBot.define do
  factory :user do
    nickname { 'test_user' }
    email { 'test_user@treasuremap.com'}
    password { 'test_user'}
  end
end

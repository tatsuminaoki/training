FactoryBot.define do
  factory :user do
    # @TODO step16でユーザ導入したらidは指定しないようにする
    id { 1 }
    name { 'test_user' }
    email { 'test@rakuten.com' }
    encrypted_password { '' }
    role { 0 }
  end
end

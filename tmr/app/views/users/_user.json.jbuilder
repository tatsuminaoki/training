json.extract! user, :id, :login_id, :password_hash, :admin_flag, :created_at, :updated_at
json.url user_url(user, format: :json)

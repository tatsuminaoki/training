# frozen_string_literal: true

unless User.exists?(email: 'admin@example.com')
  User.create(email: 'admin@example.com', password: 'password', password_confirmation: 'password', role: User.roles[:admin])
end

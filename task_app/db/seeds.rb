# frozen_string_literal: true

User.create(email: 'admin@gmail.com', password: 'password123', password_confirmation: 'password123') unless User.exists?(email: 'admin@gmail.com')

require 'bcrypt'

User.create(name: 'John', email: 'test@example.com', roles: 'admin', password_digest: BCrypt::Password.create('mypassword'))

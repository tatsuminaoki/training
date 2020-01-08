require 'bcrypt'

User.create(name: 'John', email: 'test@example.com', password_digest: BCrypt::Password.create('mypassword'))

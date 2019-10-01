
User.seed do |s|
  s.id = 1
  s.login_id = 'foo'
  s.password_digest = 'Foo12345'
end

User.seed do |s|
  s.id = 2
  s.login_id = 'bar'
  s.password_digest = 'Bar12345'
end

User.seed do |s|
  s.id = 3
  s.login_id = 'baz'
  s.password_digest = 'Baz12345'
end

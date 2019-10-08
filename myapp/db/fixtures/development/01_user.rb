# frozen_string_literal: true

User.seed do |s|
  s.id = 1
  s.login_id = 'foo'
  s.password = 'Foo12345'
  s.admin = 1
end

User.seed do |s|
  s.id = 2
  s.login_id = 'bar'
  s.password = 'Bar12345'
  s.admin = 0
end

User.seed do |s|
  s.id = 3
  s.login_id = 'baz'
  s.password = 'Baz12345'
  s.admin = 0
end

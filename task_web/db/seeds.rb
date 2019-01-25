# frozen_string_literal: true

5.times do |i|
  User.create!(
      email: "gosuke.yasufuku+#{i}@fablic.co.jp",
      name: "ごうすけ #{i}",
      password: "rakuten#{i}",
      auth_level: 5,
  )
end

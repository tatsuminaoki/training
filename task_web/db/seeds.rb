# frozen_string_literal: true

5.times do |i|
  User.create!(
      email: "gosuke.yasufuku+#{i}@fablic.co.jp",
      name: "ごうすけ #{i}",
      password: "rakuten#{i}",
      auth_level: :admin,
  )
end
Label.create!(
    [
      { name: 'トレーニング' },
      { name: '学習' },
      { name: '家事' },
      { name: '自分' },
      { name: '遊び' },
      { name: '仕事' },
      { name: 'その他' },
    ],
)

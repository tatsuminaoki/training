# coding: utf-8
User.create!(
  [
    {
      name: '楽天花子',
      email: 'hanako.rakuten@rakuten.com',
      password_digest: '',
      role: 0
    },
    {
      name: '楽天太郎',
      email: 'taro.rakuten@rakuten.com',
      password_digest: '',
      role: 0
    },
    {
      name: '管理者太郎',
      email: 'taro.admin@rakuten.com',
      password_digest: '',
      role: 1
    }
  ]
)

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

userobj = {
  _email: ['aaaaa', 0, '@gmail.com'],
  password_digest: 'passwaaada',
  name: 'おなまえ',
  group_id: nil,
  role: 1
}

taskobj = {
  title: 'たすくだよ',
  description: 'たすくだよー',
  status: 1
}

# add users
10.times do |i|
  userobj[:_email][1] = i
  user = User.create(
    email: userobj[:_email].join,
    password_digest: userobj[:password_digest],
    name: userobj[:name],
    group_id: userobj[:group_id],
    role: userobj[:role]
  )

  # add tasks
  10.times do |_i|
    Task.create(
      user_id: user.id,
      title: taskobj[:title],
      description: taskobj[:description],
      status: taskobj[:status]
    )
  end
end

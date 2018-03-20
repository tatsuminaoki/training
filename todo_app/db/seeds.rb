user = User.create(name: 'admin')

1000.times do |i|
  Task.create!(
      title: "Task #{i}",
      description: 'This is sample task',
      deadline: Time.new('2018-01-01 00:00:00').getlocal + (i * 3600),
      status: %w[not_start progress done][rand(0..2)],
      priority: %w[low normal high quickly right_now][rand(0..4)],
      user_id: user.id)
end

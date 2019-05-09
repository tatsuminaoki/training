# frozen_string_literal: true

5.times do |i|
  User.create!(name: "name #{i}")
end

Task.create!([
               {
                 user_id: User.first.id,
                 name: 'test task name',
                 status: 1,
                 description: 'aaaabbbbcccc',
                 due_date: Date.current.since(5.days),
               },
               {
                 user_id: User.second.id,
                 name: 'task name aaaaaa',
                 status: 2,
                 description: 'test test test',
                 due_date: Date.current.since(3.days),
               },
             ])

20.times do |i|
  Task.create!([{
                 user_id: User.first.id,
                 name: "name #{i}",
                 status: 0,
                 description: i.to_s * 20,
                 due_date: Date.current.tomorrow,
               }])
end

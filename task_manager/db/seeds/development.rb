# frozen_string_literal: true

User.create!([
               {
                 name: '名前テスト',
               },
               {
                 name: 'test name',
               },
             ])

Task.create!([
               {
                 user_id: User.first.id,
                 name: 'test task name',
                 status: 1,
                 description: 'test test test',
                 due_date: Date.current.tomorrow,
               },
               {
                 user_id: User.second.id,
                 name: 'test task name aaaaaa',
                 status: 2,
                 description: 'test test test',
                 due_date: Date.current.since(3.days),
               },
             ])

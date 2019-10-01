# frozen_string_literal: true

foo = User.find_by(login_id: 'foo')
bar = User.find_by(login_id: 'bar')
baz = User.find_by(login_id: 'baz')

Task.seed(:id,
  { :id => 1, :title => 'fooのタスク1', :description => '未着手のタスクです', :user_id => foo[:id], :status => Task.statuses[:waiting] },
  { :id => 2, :title => 'fooのタスク2', :description => '着手中のタスクです', :user_id => foo[:id], :status => Task.statuses[:working] },
  { :id => 3, :title => 'fooのタスク3', :description => '完了したタスクです', :user_id => foo[:id], :status => Task.statuses[:completed] },
  { :id => 4, :title => 'barのタスク1', :description => '未着手のタスクです', :user_id => bar[:id], :status => Task.statuses[:waiting] },
  { :id => 5, :title => 'barのタスク2', :description => '着手中のタスクです', :user_id => bar[:id], :status => Task.statuses[:working] },
  { :id => 6, :title => 'barのタスク3', :description => '完了したタスクです', :user_id => bar[:id], :status => Task.statuses[:completed] },
  { :id => 7, :title => 'bazのタスク1', :description => '未着手のタスクです', :user_id => baz[:id], :status => Task.statuses[:waiting] },
  { :id => 8, :title => 'bazのタスク2', :description => '着手中のタスクです', :user_id => baz[:id], :status => Task.statuses[:working] },
  { :id => 9, :title => 'bazのタスク3', :description => '完了したタスクです', :user_id => baz[:id], :status => Task.statuses[:completed] },
)

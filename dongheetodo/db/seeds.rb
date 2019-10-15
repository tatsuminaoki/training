require 'factory_bot'
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# ユーザを生成
user = FactoryBot.create(:user, email: 'init@example.com', password: 'hogehoge')
tasks = []
labels = []
# タスクを100件生成
100.times do
  tasks.push(FactoryBot.create(:task, user_id: user.id))
end
# ラベルを5個生成
5.times do
  labels.push(FactoryBot.create(:label))
end
# TaskとLabelを紐づく（ランダムに付与）
300.times do
  begin
    FactoryBot.create(:task_label, task: tasks.sample, label: labels.sample)
  rescue
    next
  end
end

FactoryBot.define do
  factory :task do
    name 'test_task'
    user_id 0 # ユーザー機能実装時に修正する
    description 'description'
    priority 0
    status 0
    label_id 0 # ラベル機能実装時に修正する
    end_date Time.zone.today
  end
end

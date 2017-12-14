FactoryBot.define do
  factory :task do
    name 'test_task'
    user # ユーザー機能実装時に修正する
    description 'description'
    priority 0
    status Task.statuses[:not_started]
    label_id 0 # ラベル機能実装時に修正する
    end_date Time.zone.today
  end
end

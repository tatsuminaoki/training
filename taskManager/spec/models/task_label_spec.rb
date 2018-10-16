require 'rails_helper'

RSpec.describe TaskLabel, type: :model do
  before do
    @label = FactoryBot.create(:label)
    @task = FactoryBot.create(:task)
  end
  context '登録テスト' do
    it "存在するタスクID、ラベルIDでであれば有効な状態であること" do
      task_label = FactoryBot.create(:task_label, label_id: @label.id, task_id: @task.id)
      expect(task_label.errors).to_not have_key(:label_id)
      expect(task_label.errors).to_not have_key(:task_id)
    end
    it "存在しないタスクIDであれば無効な状態であること" do
      expect do
        FactoryBot.create(
          :task_label, label_id: @label.id, task_id: @task.id + 100
        )
      end.to raise_error(ActiveRecord::RecordInvalid)
    end
    it "存在しないラベルIDであれば無効な状態であること" do
      expect do
        FactoryBot.create(
          :task_label, label_id: @label.id + 100, task_id: @task.id
        )
      end.to raise_error(ActiveRecord::RecordInvalid)
    end
  end
end

require 'rails_helper'

RSpec.describe TaskLabel, type: :model do
  let(:user) { FactoryBot.create(:user, email: 'task_label@example.com') }
  let(:task) { FactoryBot.create(:task, user: user) }
  let(:label) { FactoryBot.create(:label, name: 'test', user: user) }

  context 'task_idとlabel_idの組み合わせが重複している場合' do
    it '登録できない' do
      FactoryBot.create(:task_label, task: task, label: label)
      task_label = FactoryBot.build(:task_label, task: task, label: label)
      expect(task_label.valid?).to eq false
    end
  end

  context 'task_idとlabel_idの組み合わせが重複していない場合' do
    it '登録できない' do
      task_label = FactoryBot.build(:task_label, task: task, label: label)
      expect(task_label.valid?).to eq true
    end
  end
end

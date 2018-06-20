require 'rails_helper'

RSpec.describe Task, type: :model do
  context '正常なタスク' do
    let(:task) {Task.new(task_name: 'task')}
    it '新規作成' do
      expect(task.validate).to be_truthy
    end

    it '更新' do
      expect(task.validate).to be_truthy
    end
  end

  context '空白のタスク' do
    let(:task) {Task.new(task_name: nil)}
    it '新規作成' do
      expect(task.validate).to be_falsy
      expect(task.errors).to have_key(:task_name)
      expect(task.errors.full_messages).to eq ['タスク名を入力してください。']
    end

    it '更新' do
      expect(task.validate).to be_falsy
      expect(task.errors).to have_key(:task_name)
      expect(task.errors.full_messages).to eq ['タスク名を入力してください。']
    end
  end

  context '256文字以上のタスク' do
    let(:task) {Task.new(task_name: 'a'*256)}
    it '新規作成' do
      expect(task.validate).to be_falsy
      expect(task.errors).to have_key(:task_name)
      expect(task.errors.full_messages).to eq ['タスク名は255字以内で入力してください。']
    end

    it '更新' do
      expect(task.validate).to be_falsy
      expect(task.errors).to have_key(:task_name)
      expect(task.errors.full_messages).to eq ['タスク名は255字以内で入力してください。']
    end
  end

end

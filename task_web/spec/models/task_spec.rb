# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'タスクモデルのテスト', type: :model do
  describe 'タスク' do
    let!(:input) {
      { name: '買い物', description: '説明文', due_date: Time.zone.today, priority: 2, user_id: 1, created_at: Time.zone.now }
    }
    let!(:task) {
      create(:task, input)
    }
    it '有効であること' do
      expect(task).to be_valid
      expect(task.name).to eq input[:name]
      expect(task.description).to eq input[:description]
      expect(task.due_date == input[:due_date])
      expect(task.priority == input[:priority])
      expect(task.user_id == input[:user_id])
      expect(task.created_at == input[:created_at])
    end
    it 'タスク名は必須であること' do
      task = Task.new input.merge(name: nil)
      expect(task).not_to be_valid
      expect(task.errors[:name][0]).to eq 'タスク名が空です'
    end
    it '説明文は任意であること' do
      task = Task.new input.merge(description: nil)
      expect(task).to be_valid
    end
    it '期限は必須であること' do
      task = Task.new input.merge(due_date: nil)
      expect(task).not_to be_valid
      expect(task.errors[:due_date][0]).to eq '期限が空です'
    end
    it '優先度は必須であること' do
      task = Task.new input.merge(priority: nil)
      expect(task).not_to be_valid
      expect(task.errors[:priority][0]).to eq '優先度が空です'
    end
    it 'ユーザIDは必須であること' do
      task = Task.new input.merge(user_id: nil)
      expect(task).not_to be_valid
      expect(task.errors[:user_id][0]).to eq 'ユーザIDが空です'
    end
    it 'タスク名の文字数制限を超えて入力できないこと' do
      task = Task.new input.merge(name: ('1' * 21))
      expect(task).not_to be_valid
      expect(task.errors[:name][0]).to eq 'タスク名は２０文字まで利用できます'
    end
    it '説明文の文字数制限を超えて入力できないこと' do
      task = Task.new input.merge(description: ('1' * 201))
      expect(task).not_to be_valid
      expect(task.errors[:description][0]).to eq '説明文は２００文字まで利用できます'
    end
    it '優先度にマイナスの値を入力できないこと' do
      expect {
        Task.new input.merge(priority: -1)
      }.to raise_error(ArgumentError)
    end
    it '優先度に2より大きい値を入力できないこと' do
      expect {
        Task.new input.merge(priority: 3)
      }.to raise_error(ArgumentError)
    end
    it 'ユーザIDに0が入力できないこと' do
      task = Task.new input.merge(user_id: 0)
      expect(task).not_to be_valid
      expect(task.errors[:user_id][0]).to eq 'ユーザIDが不正です'
    end
    it 'ユーザIDにマイナスの値を入力できないこと' do
      task = Task.new input.merge(user_id: -1)
      expect(task).not_to be_valid
      expect(task.errors[:user_id][0]).to eq 'ユーザIDが不正です'
    end
    it 'ユーザIDに文字を入力できないこと' do
      task = Task.new input.merge(user_id: 'UserID')
      expect(task).not_to be_valid
      expect(task.errors[:user_id][0]).to eq 'ユーザIDが不正です'
    end
  end
end

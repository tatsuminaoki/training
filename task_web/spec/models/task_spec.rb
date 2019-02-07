# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'タスクモデルのテスト', type: :model do
  describe 'タスク' do
    let!(:init_user) { create(:user) }
    let!(:label) { FactoryBot.build(:label) }
    let!(:input) {
      { name: '買い物', description: '説明文', labels: [label], due_date: Time.zone.today, priority: :high,
        user: init_user, status: :closed, created_at: Time.now.getlocal().to_s }
    }
    let!(:task) {
      create(:task, input)
    }
    it '有効であること' do
      expect(task).to be_valid
      expect(task.name).to eq input[:name]
      expect(task.description).to eq input[:description]
      expect(task.labels).to eq input[:labels]
      expect(task.due_date).to eq input[:due_date]
      expect(task.priority).to eq input[:priority].to_s
      expect(task.user.id).to eq input[:user].id
      expect(task.status).to eq input[:status].to_s
      expect(task.created_at.to_s(:default)).to eq input[:created_at]
    end
    it 'タスク名は必須であること' do
      task = Task.new input.merge(name: nil)
      expect(task).not_to be_valid
      expect(task.errors.full_messages).to eq ['タスク名 が空です']
    end
    it '説明文は任意であること' do
      task = Task.new input.merge(description: nil)
      expect(task).to be_valid
    end
    it '期限は必須であること' do
      task = Task.new input.merge(due_date: nil)
      expect(task).not_to be_valid
      expect(task.errors.full_messages).to eq ['期限 が空です']
    end
    it '優先度は必須であること' do
      task = Task.new input.merge(priority: nil)
      expect(task).not_to be_valid
      expect(task.errors.full_messages[0]).to eq '優先度 が空です'
      expect(task.errors.full_messages[1]).to eq '優先度 が不正です'
    end
    it 'ユーザは必須であること' do
      task = Task.new input.merge(user_id: nil)
      expect(task).not_to be_valid
      expect(task.errors.full_messages[0]).to eq 'ユーザ情報 が必要です'
      expect(task.errors.full_messages[1]).to eq 'ユーザID が空です'
    end
    it 'ステータスは必須であること' do
      task = Task.new input.merge(status: nil)
      expect(task).not_to be_valid
      expect(task.errors.full_messages[0]).to eq 'ステータス が空です'
      expect(task.errors.full_messages[1]).to eq 'ステータス が不正です'
    end
    it 'タスク名の文字数制限を超えて入力できないこと' do
      task = Task.new input.merge(name: ('1' * 21))
      expect(task).not_to be_valid
      expect(task.errors.full_messages).to eq ['タスク名 は２０文字まで利用できます']
    end
    it '説明文の文字数制限を超えて入力できないこと' do
      task = Task.new input.merge(description: ('1' * 201))
      expect(task).not_to be_valid
      expect(task.errors.full_messages).to eq ['説明文 は２００文字まで利用できます']
    end
    it '期限に存在しない日付けを入力できないこと' do
      task = Task.new input.merge(due_date: '2018/02/31')
      expect(task).not_to be_valid
      expect(task.errors.full_messages[0]).to eq '期限 が空です'
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
      expect(task.errors.full_messages[0]).to eq 'ユーザ情報 が必要です'
      expect(task.errors.full_messages[1]).to eq 'ユーザID が不正です'
    end
    it 'ユーザIDにマイナスの値を入力できないこと' do
      task = Task.new input.merge(user_id: -1)
      expect(task).not_to be_valid
      expect(task.errors.full_messages[0]).to eq 'ユーザ情報 が必要です'
      expect(task.errors.full_messages[1]).to eq 'ユーザID が不正です'
    end
    it 'ユーザIDに文字を入力できないこと' do
      task = Task.new input.merge(user_id: 'UserID')
      expect(task).not_to be_valid
      expect(task.errors.full_messages[0]).to eq 'ユーザ情報 が必要です'
      expect(task.errors.full_messages[1]).to eq 'ユーザID が不正です'
    end
    it 'ステータスにマイナスの値を入力できないこと' do
      expect {
        Task.new input.merge(status: -1)
      }.to raise_error(ArgumentError)
    end
    it 'ステータスに2より大きい値を入力できないこと' do
      expect {
        Task.new input.merge(status: 3)
      }.to raise_error(ArgumentError)
    end
  end
end

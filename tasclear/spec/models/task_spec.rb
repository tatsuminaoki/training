# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Task, type: :model do
  describe 'バリデーション' do
    it 'タスク名と内容があれば有効な状態であること' do
      task = build(:task)
      expect(task).to be_valid
    end
    it 'タスク名がなければ無効な状態であること' do
      task = build(:task, name: '')
      expect(task).to be_invalid
    end
    it 'タスク名が20文字であれば有効な状態であること' do
      task = build(:task, name: 'あ' * 20)
      expect(task).to be_valid
    end
    it 'タスク名が21文字であれば無効な状態であること' do
      task = build(:task, name: 'あ' * 21)
      expect(task).to be_invalid
    end
    it '内容が200文字であれば有効な状態であること' do
      task = build(:task, content: 'あ' * 200)
      expect(task).to be_valid
    end
    it '内容が201文字であれば無効な状態であること' do
      task = build(:task, content: 'あ' * 201)
      expect(task).to be_invalid
    end
    it 'ステータスがnilであれば無効な状態であること' do
      task = build(:task, status: nil)
      expect(task).to be_invalid
    end
    it '優先度がnilであれば無効な状態であること' do
      task = build(:task, priority: nil)
      expect(task).to be_invalid
    end
  end
  describe '#search_and_order' do
    before do
      @task1 = create(:task, name: 'タスク１', status: 'to_do')
      @task2 = create(:task, name: 'タスク２', status: 'doing')
    end
    it 'タスク名で検索できること' do
      expect(Task.search_and_order({ search_name: 'タスク１' })).to include(@task1)
      expect(Task.search_and_order({ search_name: 'タスク１' })).not_to include(@task2)
    end
    it 'ステータスで検索できること' do
      expect(Task.search_and_order({ search_status: 'to_do' })).to include(@task1)
      expect(Task.search_and_order({ search_status: 'to_do' })).not_to include(@task2)
    end
    it 'タスク名・ステータスの両方で検索できること' do
      expect(Task.search_and_order({ search_name: 'タスク１', search_status: 'to_do' })).to include(@task1)
      expect(Task.search_and_order({ search_name: 'タスク１', search_status: 'to_do' })).not_to include(@task2)
    end
  end
end

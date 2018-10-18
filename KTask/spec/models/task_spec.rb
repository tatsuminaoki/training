# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Task, type: :model do

  before do
    @login_user = create(:user)
    @task = create(:task, user_id: @login_user.id)
  end

  context 'パラメータが正しい場合' do
    it 'タスクの有効' do
      expect(@task).to be_valid
    end
  end

  context 'パラメータが正しくない場合' do
    it 'タスクのタイトルが入れていない' do
      task = build(:task, title: nil, user_id: @login_user.id)
      expect(task).not_to be_valid
      expect(task.errors).to have_key(:title)
    end

    it 'タイトル文字の制限を超える' do
      task = build(:task, title: 'あ' * 21, user_id: @login_user.id)
      expect(task).not_to be_valid
      expect(task.errors).to have_key(:title)
    end

    it 'タスクの内容が入れていない' do
      task = build(:task, content: nil, user_id: @login_user.id)
      expect(task).not_to be_valid
      expect(task.errors).to have_key(:content)
    end
  end

  context '検索機能テスト' do
    before do
      @task1 = create(:task, id: 1, title: 'task1', status: 'yet', user_id: @login_user.id)
      @task2 = create(:task, id: 2, title: 'task2', status: 'do', user_id: @login_user.id)
    end

    it 'タスクの名で検索' do
      expect(Task.search_and_order({ search_title: 'task1' }, @login_user )).to include(@task1)
      expect(Task.search_and_order({ search_title: 'task1' }, @login_user )).not_to include(@task2)
    end

    it 'タスクの状態で検索' do
      expect(Task.search_and_order({ search_status: 'yet' }, @login_user)).to include(@task1)
      expect(Task.search_and_order({ search_status: 'yet' }, @login_user)).not_to include(@task2)
    end

    it 'タスク名と状態で検索' do
      expect(Task.search_and_order({ search_title: 'task1', search_status: 'yet' }, @login_user)).to include(@task1)
      expect(Task.search_and_order({ search_title: 'task1', search_status: 'yet' }, @login_user)).not_to include(@task2)
    end
  end
end

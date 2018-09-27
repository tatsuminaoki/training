# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Task, type: :model do
  it 'タスクの有効' do
    task = FactoryBot.create(:task)
    expect(task).to be_valid
  end
  context 'パラメータが正しい場合' do
    it 'タスクのタイトルが入れている' do
      task = FactoryBot.create(:task, title: 'Test content')
      expect(task).to be_valid
    end
    it 'タイトル文字の制限を超えない' do
      task = FactoryBot.create(:task, title: 'あ' * 20)
      expect(task).to be_valid
    end
    it 'タスクの内容が入れている' do
      task = FactoryBot.create(:task, content: 'content valid test')
      expect(task).to be_valid
    end
  end
  context 'パラメータが正しくない場合' do
    it 'タスクのタイトルが入れていない' do
      task = FactoryBot.create(:task, title: nil)
      expect(task).to be_valid
    end
    it 'タイトル文字の制限を超える' do
      task = FactoryBot.create(:task, title: 'あ' * 21)
      expect(task).to be_valid
    end
    it 'タスクの内容が入れていない' do
      task = FactoryBot.create(:task, content: nil)
      expect(task).to be_valid
    end
  end
end

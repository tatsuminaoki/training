require 'rails_helper'

RSpec.describe Task, type: :model do
  describe '#validation' do
    it '正常な値で登録できる' do
      task = build(:task)
      expect(task).to be_valid
    end

    it '不正なタイトルで登録するとタイトルエラーが発生する' do
      task = build(:task, title: nil)
      expect(task).to be_invalid
      expect(task.errors[:title]).to be_present
    end

    it '不正なステータスで登録するとステータスエラーが発生する' do
      task = build(:task, status: nil)
      expect(task).to be_invalid
      expect(task.errors[:status]).to be_present
    end

    it '不正な優先度で登録すると優先度エラーが発生する' do
      task = build(:task, priority: nil)
      expect(task).to be_invalid
      expect(task.errors[:priority]).to be_present
    end
  end

  describe '#search' do
    it 'タイトルでキーワードを検索できる' do
      create(:task, title: 'Rspec Search Test')
      @search_result = Task.search('Rspec')
      expect(@search_result).to exist
      expect(@search_result[0].title).to eq('Rspec Search Test')
    end

    it '説明文でキーワードを検索できる' do
      create(:task, description: 'Rspec Search Test')
      @search_result = Task.search('Rspec')
      expect(@search_result).to exist
      expect(@search_result[0].description).to eq('Rspec Search Test')
    end
  end

  describe '#sortable' do
    it 'sortableメソッドで配列が返ってくる' do
      @sortable = Task.sortable
      expect(@sortable).to match_array(['priority','due_date'])
    end
  end
end

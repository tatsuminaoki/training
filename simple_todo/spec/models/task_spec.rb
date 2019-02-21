require 'rails_helper'

RSpec.describe Task, type: :model do
    
    it 'valid if task has all required contents' do
      task = create(:task)
      expect(task).to be_valid
    end

    it 'invalid if one or more required contents are missing' do
      task = Task.new(
        title: '',
        description: '',
        user_id: '',
        status: '',
        limit: '2019-03-28 12:29:00'
      )
      expect(task).to be_invalid
    end

    it 'valid if title length is 40' do
      task = build(:task, title: 'a'*40)
      expect(task).to be_valid
    end

    it 'invalid if title is too long' do
      task = build(:task, title: 'a'*41)
      expect(task).to be_invalid
    end

    it 'valid if description length is 200' do
      task = build(:task, description: 'a'*200)
      expect(task).to be_valid
    end

    it 'invalid if description is too long' do
      task = build(:task, description: 'a'*201)
      expect(task).to be_invalid
    end

    it 'valid if task limit is future' do
      task = build(:task, limit: '2019-03-28 12:29:00')
      expect(task).to be_valid
    end

    it 'invalid if task limit is past' do
      task = build(:task, limit: Date.today - 1)
      expect(task).to be_invalid
    end
end

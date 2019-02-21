require 'rails_helper'

RSpec.describe Task, type: :model do
    
    it 'input all require contents' do
      task = create(:task)
      expect(task).to be_valid
    end

    it 'missing require contents ng' do
      task = Task.new(
        title: '',
        description: '',
        user_id: '',
        status: '',
        limit: '2019-03-28 12:29:00'
      )
      expect(task).to be_invalid
    end

    it 'title max length is 40' do
      task = build(:task, title: 'a'*40)
      expect(task).to be_valid
    end

    it 'title max length is 41' do
      task = build(:task, title: 'a'*41)
      expect(task).to be_invalid
    end

    it 'description length is 200' do
      task = build(:task, description: 'a'*200)
      expect(task).to be_valid
    end

    it 'description length is 201' do
      task = build(:task, description: 'a'*201)
      expect(task).to be_invalid
    end

    it 'task limit ok' do
      task = build(:task, limit: '2019-03-28 12:29:00')
      expect(task).to be_valid
    end

    it 'task limit is past' do
      task = build(:task, limit: Date.today - 1)
      expect(task).to be_invalid
    end
end
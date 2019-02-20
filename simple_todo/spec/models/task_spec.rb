require 'rails_helper'

RSpec.describe Task, type: :model do
    
    it "require contents check" do
      task = FactoryBot.create(:task)
      expect(task).to be_valid
    end

    it "require contents check ng" do

      task = Task.new(
        description: '',
        limit: '2019-03-28 12:29:00'
      )
      expect(task).to be_valid
    end

    it "title max length check ok" do

      task = Task.new(
        title: 'a'*40,
        description: '',
        user_id: 1,
        status: 1,
        limit: '2019-03-28 12:29:00'
      )
      expect(task).to be_valid
    end

    it "title max length check ng" do
      task = Task.new(
        title: 'a'*41,
        description: '',
        user_id: 1,
        status: 1,
        limit: '2019-03-28 12:29:00'
      )
      expect(task).to be_valid
    end

    it "description max length check ok" do
      task = Task.new(
        title: 'test',
        description: 'a'*200,
        user_id: 1,
        status: 1,
        limit: '2019-03-28 12:29:00'
      )
      expect(task).to be_valid
    end

    it "description max length check ng" do
      task = Task.new(
        title: 'test',
        description: 'a'*201,
        user_id: 1,
        status: 1,
        limit: '2019-03-28 12:29:00'
      )
      expect(task).to be_valid
    end

    it "limit check ok" do
      task = Task.new(
        title: 'test',
        description: 'a'*200,
        user_id: 1,
        status: 1,
        limit: '2019-03-28 12:29:00'
      )
      expect(task).to be_valid
    end

    it "limit check ng" do
      task = Task.new(
        title: 'test',
        description: 'a'*200,
        user_id: 1,
        status: 1,
        limit: Date.today - 1
      )
      expect(task).to be_valid
    end
end



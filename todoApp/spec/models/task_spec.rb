require 'rails_helper'

RSpec.describe Task, :type => :model do
  context 'When user creates task' do
    it 'ensures title presence' do
      task = Task.create(description: 'no title')
      expect(task).to be_invalid
    end

    it 'ensures title length is less than 50' do
      task = Task.create(title: 'a' * 51, description: 'simple description')
      expect(task).to be_invalid
    end
  end
end

require 'rails_helper'

RSpec.describe Task, type: :model do
  let(:user) { create(:user) }

  context 'When there is no validation error.' do
    it 'can create a task' do
      task = Task.new(
        title: 'test',
        user_id: user.id,
        priority: 0,
        status: 0
      )
      expect(task).to be_valid
    end

    it 'title should be less than max length.' do
      task = Task.new(
        title: 'T' * Task::TITLE_MAX_LENGTH,
        user_id: user.id,
        status: 0,
        priority: 0
      )
      expect(task).to be_valid
    end

    it 'description should be less than max length.' do
      task = Task.new(
        title: 'TEST',
        description: 'T' * Task::DESCRIPTION_MAX_LENGTH,
        user_id: user.id,
        status: 0,
        priority: 0
      )
      expect(task).to be_valid
    end
  end

  context 'When there are validation errors' do
    it 'task cannot be nil' do
      task = Task.new(
        user_id: user.id,
        priority: 0,
        status: 0
      )
      expect(task).not_to be_valid
      expect(task.errors[:title]).to be_present
    end

    it 'priority cannot be nil' do
      task = Task.new(
        title: 'TEST',
        user_id: user.id,
        status: 0
      )
      expect(task).not_to be_valid
      expect(task.errors[:priority]).to be_present
    end

    it 'status cannot be nil' do
      task = Task.new(
        title: 'TEST',
        user_id: user.id,
        priority: 0
      )
      expect(task).not_to be_valid
      expect(task.errors[:status]).to be_present
    end

    it 'title should cannot be more than max length.' do
      task = Task.new(
        title: 'T' * (Task::TITLE_MAX_LENGTH + 1),
        user_id: user.id,
        status: 0,
        priority: 0
      )
      expect(task).not_to be_valid
      expect(task.errors[:title]).to be_present
    end

    it 'description cannot be more than max length.' do
      task = Task.new(
        title: 'TEST',
        description: 'T' * (Task::DESCRIPTION_MAX_LENGTH + 1),
        user_id: user.id,
        status: 0,
        priority: 0
      )
      expect(task).not_to be_valid
      expect(task.errors[:description]).to be_present
    end
  end
end

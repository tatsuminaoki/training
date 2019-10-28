require 'rails_helper'

RSpec.describe Task, type: :model do
  let(:user) { create(:user) }

  context 'When there is no validation error.' do
    let(:task) { create(:task, user_id: user.id) }
    it 'can create a task' do
      expect(task).to be_valid
    end
  end

  context 'When the length of title is less than max length' do
    let(:task) { create(:task, user_id: user.id, title: 'T' * 255) }
    it 'can create a task' do
      expect(task).to be_valid
    end
  end

  context 'When the length of description is less than max length' do
    let(:task) { create(:task, user_id: user.id, description: 'T' * 512) }
    it 'can create a task' do
      expect(task).to be_valid
    end
  end

  context 'When the title is nil' do
    let(:task) { Task.new(user_id: user.id, priority: 0, status: 0) }
    it 'title cannot be nil' do
      expect(task).not_to be_valid
      expect(task.errors[:title]).to be_present
    end
  end

  context 'When the priority is nil' do
    let(:task) { Task.new(title: 'TEST', user_id: user.id, status: 0) }
    it 'priority cannot be nil' do
      expect(task).not_to be_valid
      expect(task.errors[:priority]).to be_present
    end
  end

  context 'When the status is nil' do
    let(:task) { Task.new(title: 'TEST', user_id: user.id, priority: 0) }
    it 'status cannot be nil' do
      expect(task).not_to be_valid
      expect(task.errors[:status]).to be_present
    end
  end

  context 'When the title is be more than max length' do
    let(:task) { Task.new(title: 'T' * 256, user_id: user.id, status: 0, priority: 0) }
    it 'title cannot be more than max length' do
      expect(task).not_to be_valid
      expect(task.errors[:title]).to be_present
    end
  end

  context 'When the description is be more than max length' do
    let(:task) { Task.new(title: 'TEST', description: 'T' * 513, user_id: user.id, status: 0, priority: 0) }
    it 'description cannot be more than max length.' do
      expect(task).not_to be_valid
      expect(task.errors[:description]).to be_present
    end
  end

  context 'When searching with title' do
    let!(:task) { create(:task, user_id: user.id, title: 'hoge') }
    it 'the record which has that title is found' do
      expect(Task.find_by(title: 'hoge')).to have_attributes(title: 'hoge')
    end
  end

  context 'When searching with status' do
    let!(:task) { create(:task, user_id: user.id, status: 1) }
    it 'the record which has that status is found' do
      expect(Task.find_by(status: 'InProgress')).to have_attributes(status: 'InProgress')
    end
  end
end

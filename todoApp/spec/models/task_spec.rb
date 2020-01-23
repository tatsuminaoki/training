require 'rails_helper'

RSpec.describe Task, :type => :model do
  context 'When user searching' do
    before do
      Task.create!(title: 'title keyword', status: 'todo')
      Task.create!(title: 'i am not', status: 'ongoing')
    end

    it 'should return only searched title when searched by title' do
      expect(Task.search_by_title('title keyword').pluck(:title)).to eq(['title keyword'])
    end

    it 'should return only searched status when searched by status' do

    end
  end

  describe '#filtering' do
    let!(:user1) { User.create(name: 'John', email: 'user1@example.com', password_digest: BCrypt::Password.create('u1password')) }
    let!(:user2) { User.create(name: 'Mary', email: 'user2@example.com', password_digest: BCrypt::Password.create('u2password')) }
    let!(:task1) { Task.create(title: 'user1 task', user_id: user1.id) }
    let!(:task2) { Task.create(title: 'user2 task', user_id: user2.id) }

    context 'only return tasks owned by user' do
      it {
        expect(Task.own_by(user1.id)).to eq([task1])
      }
    end
  end

  describe '#labels' do
    let!(:user1) { User.create(name: 'John', email: 'user1@example.com', password: 'u1password') }
    let!(:task1) { Task.create(title: 'user1 task', user_id: user1.id) }
    let!(:label1) { Label.create!(name: 'first label') }

    context 'when task destroyed the task-label assciation also be destroyed' do
      it {
        task1.labels << label1
        Task.find(task1.id).destroy
        expect(TaskLabel.where(task_id: task1.id)).to eq([])
      }
    end
  end

  describe '#search with labels' do
    let!(:user1) { User.create(name: 'John', email: 'user1@example.com', password: 'u1password') }
    let!(:task1) { Task.create(title: 'user1 first task', user_id: user1.id) }
    let!(:task2) { Task.create(title: 'user1 second task', user_id: user1.id) }
    let!(:label1) { Label.create!(name: 'first label') }
    let!(:label2) { Label.create!(name: 'second label') }

    context 'only return searched by labels' do
      it {
        task1.labels << label1
        task2.labels << label2
        expect(Task.search_by_labels(task2.label_ids)).to eq([task2])
      }
    end
  end
end

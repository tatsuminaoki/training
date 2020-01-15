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
end

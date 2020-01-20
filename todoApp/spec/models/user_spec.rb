require 'rails_helper'

RSpec.describe User, :type => :model do
  describe 'when user destroyed' do
    let!(:user1) { User.create(name: 'John', email: 'user1@example.com', password_digest: BCrypt::Password.create('u1password')) }
    let!(:task1) { Task.create(title: 'user1 task', user_id: user1.id) }
    let!(:task2) { Task.create(title: 'user1 task2', user_id: user1.id) }

    context 'delete all related tasks' do
      it {
        expect(Task.all.count).to eq(2)
        user1.destroy!
        expect(Task.all.count).to eq(0)
      }
    end
  end
end

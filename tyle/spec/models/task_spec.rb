# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Task, type: :model do
  let(:user) { User.create(id: 1, name: 'user1', login_id: 'id1', password_digest: 'password1') }

  describe '#create' do
    context 'a task' do
      let(:task) { Task.create(name: 'task1', priority: 0, status: 0, user_id: user.id, due: '20201231') }

      it 'creates a task' do
        expect(task).to be_valid
        expect(task.errors.count).to eq(0)
      end
    end

    context 'a task without a name' do
      let(:task) { Task.create(name: nil, priority: 0, status: 0, user_id: user.id, due: '20201231') }

      it 'creates a task without a name' do
        expect(task).not_to be_valid
        expect(task.errors.count).to eq(1)
      end
    end

    context 'a task without a priority' do
      let(:task) { Task.create(name: 'task1', priority: nil, status: 0, user_id: user.id, due: '20201231') }

      it 'creates a task without a priority' do
        expect(task).not_to be_valid
        expect(task.errors.count).to eq(1)
      end
    end

    context 'a task without a status' do
      let(:task) { Task.create(name: 'task1', priority: 0, status: nil, user_id: user.id, due: '20201231') }

      it 'creates a task without a status' do
        expect(task).not_to be_valid
        expect(task.errors.count).to eq(1)
      end
    end

    context 'a task without a due' do
      let(:task) { Task.create(name: 'task1', priority: 0, status: 0, user_id: user.id, due: nil) }

      it 'creates a task without a status' do
        expect(task).not_to be_valid
        expect(task.errors.count).to eq(1)
      end
    end


    it 'a task with priority number over' do
      expect { Task.create(name: 'task1', priority: 4, status: 0, user_id: user.id, due: '20201231') }.to raise_error(ArgumentError)
    end

    it 'a task with priority number under' do
      expect { Task.create(name: 'task1', priority: -1, status: 0, user_id: user.id, due: '20201231') }.to raise_error(ArgumentError)
    end

    it 'a task with status number over' do
      expect { Task.create(name: 'task1', priority: 0, status: 4, user_id: user.id, due: '20201231') }.to raise_error(ArgumentError)
    end

    it 'a task with status number under' do
      expect { Task.create(name: 'task1', priority: 0, status: -1, user_id: user.id) }.to raise_error(ArgumentError)
    end
  end
end

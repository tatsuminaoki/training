# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Task, type: :model do
  let(:user) { create(:user) }

  describe '#create' do
      let(:task) { create(:task, { user_id: user.id }) }

    it 'creates a task' do
      expect(task).to be_valid
      expect(task.errors.count).to eq(0)
    end

    it 'creates a task without a name' do
      expect{ create(:task, { name: nil, user_id: user.id }) }.to raise_error(ActiveRecord::RecordInvalid)
    end

    it 'creates a task without a priority' do
      expect { create(:task, { priority: nil, user_id: user.id }) }.to raise_error(ActiveRecord::RecordInvalid)
    end

    it 'creates a task without a status' do
      expect { create(:task, { status: nil, user_id: user.id }) }.to raise_error(ActiveRecord::RecordInvalid)
    end

    it 'creates a task without a status' do
      expect { create(:task, { due: nil, user_id: user.id }) }.to raise_error(ActiveRecord::RecordInvalid)
    end

    it 'a task with priority number over' do
      expect { create(:task, { priority: 4, user_id: user.id }) }.to raise_error(ArgumentError)
    end

    it 'a task with priority number under' do
      expect { create(:task, { priority: -1, user_id: user.id }) }.to raise_error(ArgumentError)
    end

    it 'a task with status number over' do
      expect { create(:task, { status: 4, user_id: user.id }) }.to raise_error(ArgumentError)
    end

    it 'a task with status number under' do
      expect { create(:task, { status: -1, user_id: user.id }) }.to raise_error(ArgumentError)
    end
  end
end

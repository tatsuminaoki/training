# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Task, type: :model do
  let(:admin_user) { create(:admin_user) }

  describe '#create' do
    let(:task) { build(:task, { user_id: admin_user.id }) }

    before do
      task.save
    end

    it 'successfully creates a task' do
      expect(task).to be_valid
      expect(task.errors.count).to eq(0)
    end

    context 'without a name' do
      let(:task) { build(:task, { name: nil, user_id: admin_user.id }) }

      it 'shows the error message' do
        expect(task.errors[:name]).to include('を入力してください')
      end
    end

    context 'without a priority' do
      let(:task) { build(:task, { priority: nil, user_id: admin_user.id }) }

      it 'shows the error message' do
        expect(task.errors[:priority]).to include('を入力してください')
      end
    end

    context 'without a status' do
      let(:task) { build(:task, { status: nil, user_id: admin_user.id }) }

      it 'shows the error message' do
        expect(task.errors[:status]).to include('を入力してください')
      end
    end

    context 'without a due' do
      let(:task) { build(:task, { due: nil, user_id: admin_user.id }) }

      it 'shows the error message' do
        expect(task.errors[:due]).to include('を入力してください')
      end
    end

    context 'with priority number over' do
      it 'show the argument error' do
        expect { create(:task, { priority: 4, user_id: admin_user.id }) }.to raise_error(ArgumentError)
      end
    end

    context 'with priority number under' do
      it 'show the argument error' do
        expect { create(:task, { priority: -1, user_id: admin_user.id }) }.to raise_error(ArgumentError)
      end
    end

    context 'with status number over' do
      it 'show the argument error' do
        expect { create(:task, { status: 4, user_id: admin_user.id }) }.to raise_error(ArgumentError)
      end
    end

    context 'with priority number under' do
      it 'show the argument error' do
        expect { create(:task, { priority: -1, user_id: admin_user.id }) }.to raise_error(ArgumentError)
      end
    end
  end
end

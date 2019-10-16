# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Task, type: :model do
  context 'title cannot be nil' do
    it 'should return error' do
      task = Task.new(title: nil, body: 'test')
      expect { task.save! }.to raise_error(ActiveRecord::RecordInvalid)
      expect(task.valid?).to eq false
    end
  end

  context 'title cannot allow empty string' do
    it 'should return error' do
      task = Task.new(title: '', body: 'test')
      expect { task.save! }.to raise_error(ActiveRecord::RecordInvalid)
      expect(task.valid?).to eq false
    end
  end

  context 'task searching' do
    let!(:user1) { create(:user) }
    let!(:task1) { Task.create(title: 'task1', aasm_state: 'not_yet', user: user1) }
    let!(:task2) { Task.create(title: 'task2', aasm_state: 'on_going', user: user1) }
    let!(:task3) { Task.create(title: 'task3', aasm_state: 'done', user: user1) }
    let!(:task4) { Task.create(title: 'task4', aasm_state: 'on_going', user: user1) }
    subject { Task.ransack(params).result(distinct: true) }
    context 'search with non exist title' do
      let(:params) { { title_cont: 'not exist', aasm_state_eq: '' } }
      it 'should return 0 result' do
        expect(subject.count).to eq 0
      end
    end
    context 'search with existed title' do
      let(:params) { { title_cont: 'task', aasm_state_eq: '' } }
      it 'should return 4 result' do
        expect(subject.count).to eq 4
      end
    end
    context 'search with aasm_state' do
      let(:params) { { title_cont: '', aasm_state_eq: 'on_going' } }
      it 'should return 2 result' do
        expect(subject.count).to eq 2
      end
    end
  end
end

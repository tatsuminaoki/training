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
end

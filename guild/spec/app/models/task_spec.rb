require 'rails_helper'
require 'value_objects/state'
require 'value_objects/priority'
require 'value_objects/label'

RSpec.describe Task, type: :model do
  describe '#create' do
    describe 'columun:user_id' do
      context 'Valid value' do
        it 'Create·correctly' do
            task = Task.new(user_id: 1)
            task.valid?
            expect(task.errors[:user_id].count).to eq 0
        end
      end
      context 'Invalid value' do
        it 'User_id is nil' do
            task = Task.new()
            task.valid?
            expect(task.errors[:user_id][0]).to eq "can't be blank"
        end
        it 'User_id is not numerical' do
            task = Task.new(user_id: 'test')
            task.valid?
            expect(task.errors[:user_id][0]).to eq "is not a number"
        end
      end
    end
    describe 'Columun:subject' do
      context 'Valid value' do
        it 'Create·correctly' do
            task = Task.new(subject: 'test')
            task.valid?
            expect(task.errors[:subject].count).to eq 0
        end
      end
      context 'Invalid value' do
        it 'Subject is nil' do
            task = Task.new
            task.valid?
            expect(task.errors[:subject][0]).to eq "can't be blank"
        end
      end
    end
    describe 'Columun:state' do
      context 'Valid value' do
        it 'Create·correctly' do
            task = Task.new(state: 1)
            task.valid?
            expect(task.errors[:state].count).to eq 0
        end
      end
      context 'Invalid value' do
        it 'State is nil' do
            task = Task.new
            task.valid?
            expect(task.errors[:state][0]).to eq "can't be blank"
        end
        it 'State is invalid' do
            task = Task.new(state: ValueObjects::State.get_list.count + 1)
            task.valid?
            expect(task.errors[:state][0]).to eq "is not included in the list"
        end
      end
    end
    describe 'Columun:priority' do
      context 'Valid value' do
        it 'Create·correctly' do
            task = Task.new(priority: 1)
            task.valid?
            expect(task.errors[:priority].count).to eq 0
        end
      end
      context 'Invalid value' do
        it 'Priority is nil' do
            task = Task.new
            task.valid?
            expect(task.errors[:priority][0]).to eq "can't be blank"
        end
        it 'Priority is invalid' do
            task = Task.new(priority: ValueObjects::Priority.get_list.count + 1)
            task.valid?
            expect(task.errors[:priority][0]).to eq "is not included in the list"
        end
      end
    end
    describe 'Columun:label' do
      context 'Valid value' do
        it 'Create·correctly' do
            task = Task.new(label: 1)
            task.valid?
            expect(task.errors[:label].count).to eq 0
        end
      end
      context 'Invalid value' do
        it 'Label is nil' do
            task = Task.new
            task.valid?
            expect(task.errors[:label][0]).to eq "can't be blank"
        end
        it 'Label is invalid' do
            task = Task.new(label: ValueObjects::Label.get_list.count + 1)
            task.valid?
            expect(task.errors[:label][0]).to eq "is not included in the list"
        end
      end
    end
  end
end

# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Task, type: :model do
  describe 'Validates' do
    context 'Name is set correctly' do
      it 'is validate pass' do
        project = create(:project, :with_group)
        task = Task.new(name: 'test1', description: 'test1', priority: 'high', group_id: project.groups.first.id)
        expect(task.valid?).to eq true
      end
    end

    context 'Name is set to nil' do
      it 'is validation no pass and it also show errors message' do
        project = create(:project, :with_group)
        task = Task.new(name: nil, description: 'test1', priority: 'high', group_id: project.groups.first.id)
        task.valid?
        expect(task.errors.messages[:name]).to eq ["can't be blank"]
      end
    end

    context 'Verify end_period_at' do
      context 'Name is set empty' do
        it 'is verify_end_period_at pass' do
          project = create(:project, :with_group)
          task = Task.new(name: nil, description: 'test1', priority: 'high', group: project.groups.first, end_period_at: nil)
          task.valid?
          expect(task.errors.messages[:end_period_at]).to eq []
        end
      end

      context 'End_period_at date is future than current' do
        it 'is verify_end_period_at pass' do
          project = create(:project, :with_group)
          task = Task.new(name: nil, description: 'test1', priority: 'high', group: project.groups.first, end_period_at: Time.current + 10.days)
          task.valid?
          expect(task.errors.messages[:end_period_at]).to eq []
        end
      end

      context 'End_period_at date is same to current' do
        it 'is verify_end_period_at pass' do
          project = create(:project, :with_group)
          task = Task.new(name: nil, description: 'test1', priority: 'high', group: project.groups.first, end_period_at: Time.current)
          task.valid?
          expect(task.errors.messages[:end_period_at]).to eq []
        end
      end

      context 'End_period_at date is old than current' do
        it 'is got valid error' do
          project = create(:project, :with_group)
          task = Task.new(name: nil, description: 'test1', priority: 'high', group: project.groups.first, end_period_at: Time.current - 2.days)
          task.valid?
          expect(task.errors.messages[:end_period_at]).to eq ["End period date is old than current"]
        end
      end
    end
  end
end

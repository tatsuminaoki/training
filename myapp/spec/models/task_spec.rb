require 'rails_helper'

RSpec.describe Task, type: :model do
  describe 'Validates' do
    context 'nameが正しく設定されている' do
      example 'validationが通る' do
        project = create(:project, :with_group)
        task = Task.new(name: 'test1', description: 'test1', priority: 'high', group_id: project.groups.first.id)
        expect(task.valid?).to eq true
      end
    end

    context 'nameがnil' do
      example 'バリデーションが通らないし、エラーメッセージを返す' do
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

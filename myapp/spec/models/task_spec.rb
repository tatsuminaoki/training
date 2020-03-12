require 'rails_helper'

RSpec.describe Task, type: :model do
  describe 'validates name' do
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
  end
end

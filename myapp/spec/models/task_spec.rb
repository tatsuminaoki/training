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
  end
end

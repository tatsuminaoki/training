require 'rails_helper'

RSpec.describe Project, type: :model do
  describe 'Validates' do
    context 'Name is set correctly' do
      it 'is validate pass' do
        expect(Project.new(name: 'test').valid?).to eq true
      end
    end

    context 'Name is nil' do
      it 'is validation no pass and it also show errors message' do
        project = Project.new(name: nil)
        project.valid?
        expect(project.errors.messages[:name]).to eq ["can't be blank"]
      end
    end

    context 'name is empty' do
      it 'is validation no pass and it also show errors message' do
        project = Project.new(name: '')
        project.valid?
        expect(project.errors.messages[:name]).to eq ["can't be blank"]
      end
    end
  end

  describe 'Method create!' do
    context 'create! is success' do
      example 'creating 1 project and reference 4 groups' do
        Project.new(name: 'test').create!

        expect(Project.count).to eq 1
        expect(Group.count).to eq 4
      end
    end
  end
end

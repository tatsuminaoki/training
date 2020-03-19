# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Group, type: :model do
  describe 'Validates' do
    context 'Name is set correctly' do
      it 'is validation pass' do
        project = create(:project)
        group = Group.new(name: 'test1 group', sort_number: 1, project: project)
        expect(group.valid?).to eq true
      end
    end

    context 'Name is set empty' do
      it 'is validation no pass and it also show errors message' do
        project = create(:project)
        group = Group.new(name: 'test1 group', sort_number: 1, project: project)
        group.valid?
        expect(group.errors.messages[:name]).to eq []
      end
    end

    context 'Sort_number' do
      context 'Sort_number is set correctly' do
        it 'is validation pass' do
          project = create(:project)
          group = Group.new(name: 'test1 group', sort_number: 1, project: project)
          expect(group.valid?).to eq true
        end
      end

      context 'Sort_number is set empty' do
        it 'is verify_end_period_at pass' do
          project = create(:project)
          group = Group.new(name: 'test1 group', sort_number: nil, project: project)
          group.valid?
          expect(group.errors.messages[:sort_number]).to eq ["can't be blank"]
        end
      end

      context 'Same sort_number is already exists' do
        it 'is got valid error' do
          project = create(:project, :with_group)
          group_1 = Group.new(name: 'test1 group', sort_number: 1, project: project)
          group_2 = Group.new(name: 'test1 group', sort_number: 1, project: project)
          group_2.valid?
          expect(group_2.errors.messages[:sort_number]).to eq ['Already same sort_number']
        end
      end
    end
  end
end

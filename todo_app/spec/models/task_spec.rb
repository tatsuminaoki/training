require 'rails_helper'

RSpec.describe Task, type: :model do
  describe 'validations' do
    describe 'name' do
      context 'when blank' do
        let(:task) { build(:task, name: nil) }

        it 'to be an error' do
          expect(task.valid?).to be_falsy
          expect(task.errors[:name]).not_to be_empty
        end
      end

      context 'when presence' do
        let(:task) { build(:task) }

        it 'not to be an error' do
          expect(task.valid?).to be_truthy
          expect(task.errors[:name]).to be_empty
        end
      end
    end
  end
end

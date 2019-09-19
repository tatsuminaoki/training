# frozen_string_literal: true

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

    describe 'status' do
      context 'when blank' do
        let(:task) { build(:task, status: nil) }

        it 'to be an error' do
          expect(task.valid?).to be_falsy
          expect(task.errors[:status]).not_to be_empty
        end
      end

      context 'when presence' do
        let(:task) { build(:task) }

        it 'not to be an error' do
          expect(task.valid?).to be_truthy
          expect(task.errors[:status]).to be_empty
        end
      end
    end
  end

  describe 'scopes' do
    describe '#name_like' do
      before do
        create(:task, name: 'hogehoge')
        create(:task, name: 'fugafuga')
      end

      it 'searched by by name' do
        expect(described_class.name_like('aaaa').count).to eq(0)
        expect(described_class.name_like('geho').count).to eq(1)
        expect(described_class.name_like('hoge').count).to eq(1)
      end
    end
  end
end

# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Label, type: :model do
  describe '#create' do
    let(:label) { create(:label) }

    before do
      label.save
    end

    context 'with the correct parameters' do
      it 'successfully creates a label' do
        expect(label).to be_valid
        expect(label.errors.count).to eq(0)
      end
    end

    context 'without name' do
      let(:label) { build(:label, { name: nil }) }

      it 'shows the error message' do
        expect(label.errors[:name]).to include 'を入力してください'
      end
    end

    context 'with name 8 length' do
      let(:label) { build(:label, { name: 'a' * 8 }) }

      it 'successfully create a label' do
        expect(label).to be_valid
        expect(label.errors.count).to eq(0)
      end
    end

    context 'with name 9 length' do
      let(:label) { build(:label, { name: 'a' * 9 }) }

      it 'shows the error message' do
        expect(label.errors[:name]).to include 'は8文字以内で入力してください'
      end
    end
  end
end

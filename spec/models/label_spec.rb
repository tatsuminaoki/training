# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Label, type: :model do
  describe '#save' do
    let(:label) { build(:label, name: 'a' * 10) }

    before do
      label.save
    end

    it 'creates records in label' do
      expect(label.errors.count).to eq(0)
    end

    context 'nameへの入力がない' do
    let(:label) { build(:label, name: nil) }

      it '必須のエラーメッセージが出ること' do
        expect(label.errors.count).to eq(1)
        expect(label.errors[:name]).to include('を入力してください')
      end
    end

    context 'nameへ11文字の入力があると' do
      let(:label) { build(:label, name: 'a' * 11) }

      it 'creates records in label' do
        expect(label.errors.count).to eq(1)
        expect(label.errors[:name]).to include('は10文字以内で入力してください')
      end
    end
  end
end

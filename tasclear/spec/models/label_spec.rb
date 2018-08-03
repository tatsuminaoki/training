# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Label, type: :model do
  describe 'バリデーション' do
    let(:name) { 'ほげほげ' }
    subject { build(:label, name: name) }

    context '有効' do
      context 'ラベル名が指定される' do
        it { is_expected.to be_valid }
      end

      context 'ラベル名が10文字' do
        let(:name) { 'あ' * 10 }
        it { is_expected.to be_valid }
      end
    end

    context '無効' do
      context 'ラベル名が指定されない' do
        let(:name) { '' }
        it { is_expected.to be_invalid }
      end

      context 'ラベル名が11文字' do
        let(:name) { 'あ' * 11 }
        it { is_expected.to be_invalid }
      end
    end
  end
end

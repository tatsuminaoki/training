# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'ラベルモデルのテスト', type: :model do
  describe 'ラベル' do
    context 'ラベルモデル生成時' do
      let!(:input) { { name: '家事' } }
      let!(:label) {
        create(:label, input)
      }
      it '有効であること' do
        expect(label).to be_valid
        expect(label.name).to eq input[:name]
      end
    end
    context 'ラベル名がない時' do
      let(:label) { FactoryBot.build(:label, name: nil) }
      it '無効であること' do
        expect(label).not_to be_valid
        expect(label.errors.full_messages).to eq ['ラベル名 が空です']
      end
    end
    context 'ラベル名が重複した時' do
      let!(:label_tmp) { FactoryBot.create(:label, name: 'label1') }
      let(:label) { FactoryBot.build(:label, name: 'label1') }
      it '重複したラベル名なら無効であること' do
        expect(label).not_to be_valid
        expect(label.errors.full_messages).to eq ['ラベル名 は既に使用されています。']
      end
    end
    context 'ラベル名が文字数制限数以上の時' do
      let!(:label) { build(:label, name: ('1' * 11)) }
      it '無効であること' do
        expect(label).not_to be_valid
        expect(label.errors.full_messages).to eq ['ラベル名 は10文字以下に設定して下さい。']
      end
    end
  end
end

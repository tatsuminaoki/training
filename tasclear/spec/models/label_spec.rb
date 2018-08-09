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

      context 'ラベル名が重複' do
        before do
          create(:label, name: 'ほげほげ')
        end
        it { is_expected.to be_invalid }
      end
    end
  end

  describe 'アソシエーション' do
    let(:task1) { create(:task, id: 1) }
    let(:label1) { create(:label, id: 1, name: 'label1') }

    context 'task1にlabel1を紐づけて登録するケース' do
      before do
        task1.labels << label1
      end

      it 'task_labelで関連付けできているか' do
        expect(TaskLabel.find_by(task_id: 1).label_id).to eq 1
      end

      it 'task1を消した後task_labelも削除されるか' do
        task1.destroy
        expect(TaskLabel.find_by(task_id: 1)).to eq nil
      end
    end
  end
end

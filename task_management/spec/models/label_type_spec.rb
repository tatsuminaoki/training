require 'rails_helper'

RSpec.describe LabelType, type: :model do
  describe '#validation' do
    describe 'ラベル名' do
      context '0文字の場合' do
        let(:label) {FactoryBot.build(:label_type, label_name: '')}
        it 'バリデーションエラーが発生する' do
          expect(label.validate).to be_falsy
          expect(label.errors).to have_key(:label_name)
          expect(label.errors.full_messages).to eq ['ラベルを入力してください']
        end
      end

      context '1文字の場合' do
        let(:label) {FactoryBot.build(:label_type, label_name: 'a')}
        it 'バリデーションエラーが発生しない' do
          expect(label.validate).to be_truthy
        end
      end

      context '255文字の場合' do
        let(:label) {FactoryBot.build(:label_type, label_name: 'a'*255)}
        it 'バリデーションエラーが発生しない' do
          expect(label.validate).to be_truthy
        end
      end

      context '256文字の場合' do
        let(:label) {FactoryBot.build(:label_type, label_name: 'a'*256)}
        it 'バリデーションエラーが発生する' do
          expect(label.validate).to be_falsy
          expect(label.errors).to have_key(:label_name)
          expect(label.errors.full_messages).to eq ['ラベルは255字以内で入力してください']
        end
      end

      context '既に登録されているラベルの場合' do
        before do
          FactoryBot.create(:label_type, label_name: 'a')
        end
        let(:label) {FactoryBot.build(:label_type, label_name: 'a')}
        it 'バリデーションエラーが発生する' do
          expect(label.validate).to be_falsy
          expect(label.errors).to have_key(:label_name)
          expect(label.errors.full_messages).to eq ['ラベルは既に登録されています']
        end
      end
    end
  end
end

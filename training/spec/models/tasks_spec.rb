require 'rails_helper'

RSpec.describe Task, type: :model do
  describe 'validation' do
    describe 'name' do
      let(:task) { FactoryBot.build(:task, name: name) }
      subject { task.valid? }

      context '入力が正しい場合' do
        let(:name) { 'test' }
        it { is_expected.to be true }
      end

      context '空欄の場合' do
        let(:name) { '' }
        it { is_expected.to be false }
      end

      context '文字列の長さ' do
        context '254以下の場合' do
          let(:name) { 'a' * 254 }
          it { is_expected.to be true }
        end

        context '255の場合' do
          let(:name) { 'a' * 255 }
          it { is_expected.to be true }
        end

        context '256以上の場合' do
          let(:name) { 'a' * 256 }
          it { is_expected.to be false }
        end
      end
    end
  end
end

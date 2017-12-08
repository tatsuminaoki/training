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

    describe 'user_id' do
      let(:task) { FactoryBot.build(:task, user_id: user_id) }
      subject { task.valid? }

      # TODO : User機能実装時にIDが存在することを検証する
      context '入力が正しい場合' do
        let(:user_id) { 1 }
        it { is_expected.to be true }
      end

      context '空欄の場合' do
        let(:user_id) { '' }
        it { is_expected.to be false }
      end

      context '数値でない場合' do
        let(:user_id) { 'abc' }
        it { is_expected.to be false }
      end

      context '負の数値の場合' do
        let(:user_id) { -1 }
        it { is_expected.to be false }
      end
    end

    describe 'priority' do
      let(:task) { FactoryBot.build(:task, priority: priority) }
      subject { task.valid? }

      context '入力が正しい場合' do
        let(:priority) { 1 }
        it { is_expected.to be true }
      end

      context '空欄の場合' do
        let(:priority) { '' }
        it { is_expected.to be false }
      end

      context '数値でない場合' do
        let(:priority) { 'abc' }
        it { is_expected.to be false }
      end

      context '負の数値の場合' do
        let(:priority) { -1 }
        it { is_expected.to be false }
      end
    end

    describe 'status' do
      let(:task) { FactoryBot.build(:task, status: status) }
      subject { task.valid? }

      context '入力が正しい場合' do
        let(:status) { 1 }
        it { is_expected.to be true }
      end

      context '空欄の場合' do
        let(:status) { '' }
        it { is_expected.to be false }
      end

      context '数値でない場合' do
        let(:status) { 'abc' }
        it { is_expected.to be false }
      end

      context '負の数値の場合' do
        let(:status) { -1 }
        it { is_expected.to be false }
      end
    end

    describe 'label_id' do
      let(:task) { FactoryBot.build(:task, label_id: label_id) }
      subject { task.valid? }

      context '入力が正しい場合' do

        # TODO : Label機能実装時にIDが存在することを検証する
        context '数値が設定されている場合' do
          let(:label_id) { 1 }
          it { is_expected.to be true }
        end

        context '空欄の場合' do
          let(:label_id) { '' }
          it { is_expected.to be true }
        end
      end

      context '数値でない場合' do
        let(:label_id) { 'abc' }
        it { is_expected.to be false }
      end

      context '負の数値の場合' do
        let(:label_id) { -1 }
        it { is_expected.to be false }
      end
    end

    describe 'end_data' do
      let(:task) { FactoryBot.build(:task, end_data: end_data) }
      subject { task.valid? }

      context '入力が正しい場合' do
        context '日付が設定されている場合' do
          let(:end_data) { Time.now }
          it { is_expected.to be true }
        end

        context '空欄の場合' do
          let(:end_data) { '' }
          it { is_expected.to be true }
        end
      end

      context '日付でない場合' do
        context '数値の場合' do
          let(:end_data) { 123 }
          it { is_expected.to be false }
        end

        context '文字列の場合' do
          let(:end_data) { 'abc' }
          it { is_expected.to be false }
        end
      end
    end
  end
end

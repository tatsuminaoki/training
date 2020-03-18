# frozen_string_literal: true

require 'rails_helper'

describe Task, type: :model do
  describe 'バリデーション' do
    describe '名称' do
      let(:task) { FactoryBot.build(:task, title: title) }
      subject { task }

      context '0文字の場合' do
        let(:title) { '' }
        it { is_expected.to be_invalid }
      end

      context '30文字の場合' do
        let(:title) { 'a' * 30 }
        it { is_expected.to be_valid }
      end

      context '31文字の場合' do
        let(:title) { 'a' * 31 }
        it { is_expected.to be_invalid }
      end
    end

    describe '説明' do
      let(:task) { FactoryBot.build(:task, description: description) }
      subject { task }

      context '1000文字の場合' do
        let(:description) { 'a' * 1000 }
        it { is_expected.to be_valid }
      end

      context '1001文字の場合' do
        let(:description) { 'a' * 1001 }
        it { is_expected.to be_invalid }
      end
    end
  end
end

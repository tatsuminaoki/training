# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Task, type: :model do
  describe 'validation' do
    shared_examples_for '入力を求められる' do |attribute|
      it { expect(attribute).to include('を入力してください') }
    end

    shared_examples_for '文字制限に関するエラーが発生する' do |attribute, number_of_char|
      it { expect(attribute).to include("は#{number_of_char}文字以内で入力してください") }
    end

    context '正常値のとき' do
      it '有効である' do
        expect(FactoryBot.build(:task)).to be_valid
      end
    end

    context 'タスク名が空のとき' do
      task = FactoryBot.build(:task, name: nil)
      task.valid?
      it_behaves_like '入力を求められる', task.errors[:name]
    end

    context 'タスク名が31文字のとき' do
      task = FactoryBot.build(:task, name: 'a' * 31)
      task.valid?
      it_behaves_like '文字制限に関するエラーが発生する', task.errors[:name], 30
    end

    context '説明が空のとき' do
      task = FactoryBot.build(:task, description: nil)
      task.valid?
      it_behaves_like '入力を求められる', task.errors[:description]
    end

    context '説明が201文字のとき' do
      task = FactoryBot.build(:task, description: 'a' * 201)
      task.valid?
      it_behaves_like '文字制限に関するエラーが発生する', task.errors[:description], 200
    end
  end
end

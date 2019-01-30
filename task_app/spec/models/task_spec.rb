# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Task, type: :model do
  describe 'validation' do
    shared_examples_for '入力を求められる' do |subject|
      it { expect(subject).to include('を入力してください') }
    end

    shared_examples_for '文字制限に関するエラーが発生する' do |subject, number_of_char|
      it { expect(subject).to include("は#{number_of_char}文字以内で入力してください") }
    end

    shared_examples_for '不正値とみなされる' do |subject|
      it { expect(subject).to include('は不正な値です') }
    end

    context '正常値のとき' do
      it '有効である' do
        expect(FactoryBot.build(:task)).to be_valid
      end
    end

    describe 'タスク名' do
      context '空のとき' do
        task = FactoryBot.build(:task, name: '')
        task.valid?
        it_behaves_like '入力を求められる', task.errors[:name]
      end

      context '31文字のとき' do
        task = FactoryBot.build(:task, name: 'a' * 31)
        task.valid?
        it_behaves_like '文字制限に関するエラーが発生する', task.errors[:name], 30
      end
    end

    describe '説明' do
      context '空のとき' do
        task = FactoryBot.build(:task, description: '')
        task.valid?
        it_behaves_like '入力を求められる', task.errors[:description]
      end

      context '801文字のとき' do
        task = FactoryBot.build(:task, description: 'a' * 801)
        task.valid?
        it_behaves_like '文字制限に関するエラーが発生する', task.errors[:description], 800
      end
    end

    describe '期限' do
      context '空のとき' do
        task = FactoryBot.build(:task, due_date: '')
        task.valid?
        it_behaves_like '不正値とみなされる', task.errors[:due_date]
      end

      context '存在しない日付のとき' do
        task = FactoryBot.build(:task, due_date: '20190132')
        task.valid?
        it_behaves_like '不正値とみなされる', task.errors[:due_date]
      end

      context '日付を表さない数字のとき' do
        task = FactoryBot.build(:task, due_date: '123')
        task.valid?
        it_behaves_like '不正値とみなされる', task.errors[:due_date]
      end

      context '文字列のとき' do
        task = FactoryBot.build(:task, due_date: 'abc')
        task.valid?
        it_behaves_like '不正値とみなされる', task.errors[:due_date]
      end
    end

    describe '優先度' do
      context '空のとき' do
        task = FactoryBot.build(:task, priority: '')
        task.valid?
        it_behaves_like '入力を求められる', task.errors[:priority]
      end

      context 'enumに存在しない値のとき' do
        scenario 'ArgumentErrorが発生する' do
          expect { FactoryBot.build(:task, priority: 5) }.to raise_error(ArgumentError)
        end
      end

      context '文字列のとき' do
        scenario 'ArgumentErrorが発生する' do
          expect { FactoryBot.build(:task, priority: 'abc') }.to raise_error(ArgumentError)
        end
      end
    end
  end
end

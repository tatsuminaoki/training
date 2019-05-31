# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Task, type: :model do
  describe '#save' do
    let(:task) { described_class.new(name: 'hoge') }

    it 'creates records in task' do
      task.save
      expect(Task.count).to eq(1)
      expect(task.errors.count).to eq(0)
    end

    context 'nameへの入力がない' do
      let(:task) { described_class.new(name: nil) }

      it '必須のエラーメッセージが出ること' do
        task.save

        expect(Task.count).to eq(0)
        expect(task.errors[:name]).to include('を入力してください')
      end
    end

    context 'nameへ21文字以上の入力があると' do
      let(:task) { described_class.new(name: '１２３４５６７８９０１２３４５６７８９０a') }

      it '桁数超過のエラーメッセージが出ること' do
        task.save

        expect(Task.count).to eq(0)
        expect(task.errors[:name]).to include('は20文字以内で入力してください')
      end
    end
  end
end

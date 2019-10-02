require 'rails_helper'
require 'faker'

RSpec.describe Task, type: :model do
  describe '#create' do
    let(:task) { build(:task) }

    context '正しいタスク名の場合' do
      it '正常に生成される' do
        task.name = Faker::String.random(length: 255)
        p "length: #{task.name.length}, name: #{task.name}"
        task.valid?
        expect(task).to be_truthy
      end
    end

    context 'タスク名が空白の場合' do
      it 'エラーが発生する' do
        task.name = ''
        task.valid?
        expect(task.errors.messages[:name]).to include 'を入力してください'
      end
    end

    context 'タスク名が255文字を超過する場合' do
      it 'エラーが発生する' do
        task.name = Faker::Lorem.characters(number: 256)
        task.valid?
        expect(task.errors.messages[:name]).to include 'は255文字以内で入力してください'
      end
    end

    context 'タスク詳細が255文字を超過する場合' do
      it 'エラーが発生する' do
        task.description = Faker::Lorem.characters(number: 256)
        task.valid?
        expect(task.errors.messages[:description]).to include 'は255文字以内で入力してください'
      end
    end

    context 'ステータスを選択しなかった場合' do
      it 'エラーが発生する' do
        task.status = nil
        task.valid?
        expect(task.errors.messages[:status]).to include 'を入力してください'
      end
    end

    context '優先順位を選択しなかった場合' do
      it 'エラーが発生する' do
        task.priority = nil
        task.valid?
        expect(task.errors.messages[:priority]).to include 'を入力してください'
      end
    end

    context 'enum外の変な値がステータスとして指定された場合' do
      it 'エラーが発生する' do
        wrong_status = Faker::Games::Pokemon.name
        p wrong_status
        expect{ task.status = wrong_status }.to raise_error ArgumentError
      end
    end

    context 'enum外の変な値が優先順位として指定された場合' do
      it 'エラーが発生する' do
        wrong_priority = Faker::Creature::Cat.name
        p wrong_priority
        expect{ task.priority = wrong_priority }.to raise_error ArgumentError
      end
    end
  end
end

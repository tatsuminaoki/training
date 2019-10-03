require 'rails_helper'
require 'faker'
require 'factory_bot'

RSpec.describe Task, type: :model do
  describe '#create' do
    let(:task) { build(:task) }

    context '正しいタスク名の場合' do
      it '正常に生成される' do
        task.name = Faker::String.random(length: 255)
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
        expect{ task.status = wrong_status }.to raise_error ArgumentError
      end
    end

    context 'enum外の変な値が優先順位として指定された場合' do
      it 'エラーが発生する' do
        wrong_priority = Faker::Creature::Cat.name
        expect{ task.priority = wrong_priority }.to raise_error ArgumentError
      end
    end
  end

  describe '#search' do
    let!(:user) { create(:user) }
    let!(:task1) { create(:task, user_id: user.id) }
    let!(:task2) { create(:task, user_id: user.id) }
    let!(:task3) { create(:task, user_id: user.id) }
    let!(:task4) { create(:task, user_id: user.id) }
    let!(:task5) { create(:task, user_id: user.id) }

    context '存在するタスク名で検索する場合' do
      it '検索結果を返す' do
        result = Task.search_with_name(task1.name)
        expect(result).not_to be_empty
      end
    end

    context '存在しないタスク名で検索する場合' do
      it '検索結果を返す' do
        result = Task.search_with_name(Faker::Name.name)
        expect(result).to be_empty
      end
    end

    context '存在するステータスで絞り込む場合' do
      it '検索結果を返す' do
        result = Task.search_with_status(task1.status)
        expect(result).not_to be_empty
      end
    end

    context '存在しないステータスで検索する場合' do
      it '検索結果がない' do
        result = Task.search_with_status(Faker::Sports::Football.team)
        expect(result).to be_empty
      end
    end

    context 'IDで並び替える場合' do
      it '正常に並び替える' do
        result = Task.order_by('id', 'asc')
        first_id = result.first.id
        last_id = result.last.id
        expect(first_id).to be < last_id
      end
    end

    context '完了期限で並び替える場合' do
      it '正常に並び替える' do
        result = Task.order_by('duedate', 'asc')
        first_duedate = result.first.duedate
        last_duedate = result.last.duedate
        expect(first_duedate).to be < last_duedate
      end
    end

    context '作成日で並び替える場合' do
      it '正常に並び替える' do
        result = Task.order_by('created_at', 'asc')
        first_created_at = result.first.created_at
        last_created_at = result.last.created_at
        expect(first_created_at).to be < last_created_at
      end
    end

    context 'タスク名とステータスで絞り込みつつIDの降順で並ぶ場合' do
      it '検索結果を返す' do
        result = Task.search({name: 'hoge',
                              status: Task.statuses[:doing],
                              target: 'id',
                              order: 'desc'})
        p result.length
        if result.length === 1
          expect(result).not_to be_empty
        elsif result.length > 1
          first_id = result.first.id
          last_id = result.last.id
          expect(first_id).to be > last_id
        else
          expect(result).to be_empty
        end
      end
    end
  end
end

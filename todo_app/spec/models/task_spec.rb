# frozen_string_literal: true

require 'rails_helper'

describe Task, type: :model do
  describe 'インスタンスの状態' do
    context '有効な場合' do
      it 'タイトル、期日、ステータス、優先度があれば有効な状態であること' do
        task = build(:task)
        expect(task).to be_valid
      end

      it 'タイトルが50文字以下であれば有効な状態であること' do
        task = build(:task, title: 'a' * 50)
        expect(task).to be_valid
      end

      it '説明が255文字以下であれば有効な状態であること' do
        task = build(:task, description: 'a' * 255)
        expect(task).to be_valid
      end
    end

    context '無効な場合' do
      it 'タイトルがなければ無効な状態であること' do
        task = build(:task, title: nil)
        expect(task).to be_invalid
        expect(task.errors[:title][0]).to eq I18n.t('errors.messages.empty')
      end

      it 'タイトルが51文字以上の場合、無効な状態であること' do
        task = build(:task, title: 'a' * 51)
        expect(task).to be_invalid
        expect(task.errors[:title][0]).to eq I18n.t('errors.messages.too_long', count: 50)
      end

      it '説明が256文字以上の場合、無効な状態であること' do
        task = build(:task, description:  'a' * 256)
        expect(task).to be_invalid
        expect(task.errors[:description][0]).to eq I18n.t('errors.messages.too_long', count: 255)
      end

      it '期日がなければ無効な状態であること' do
        task = build(:task, deadline: nil)
        expect(task).to be_invalid
        expect(task.errors[:deadline][0]).to eq I18n.t('errors.messages.invalid_datetime')
      end

      it '期日のフォーマットが不正な場合、無効な状態であること' do
        task = build(:task, deadline: 'Invalid datetime format')
        expect(task).to be_invalid
        expect(task.errors[:deadline][0]).to eq I18n.t('errors.messages.invalid_datetime')
      end

      it 'ステータスがなければ無効な状態であること' do
        task = build(:task, status: nil)
        expect(task).to be_invalid
        expect(task.errors[:status][0]).to eq I18n.t('errors.messages.empty')
      end

      it '優先度がなければ無効な状態であること' do
        task = build(:task, priority: nil)
        expect(task).to be_invalid
        expect(task.errors[:priority][0]).to eq I18n.t('errors.messages.empty')
      end
    end

    context 'タスクの保存' do
      it 'タスクを1件登録できること' do
        expect(Task.create(attributes_for(:task))).to be_truthy
        expect(Task.count).to eq 1
      end

      it '登録した値を取得できること' do
        create(:task)

        task = Task.find_by(title: 'Rspec test 0123')

        expect(task.title).to eq 'Rspec test 0123'
        expect(task.description).to eq 'This is a sample description'
        expect(task.deadline.strftime('%Y/%m/%d %H:%M:%S')).to eq '2018/03/01 00:00:00'
        expect(task.status).to eq 'progress' #=> should be enum key not array index
        expect(task.priority).to eq 'high' #=> should be enum key not array index
      end
    end

    context 'タスクの更新' do
      it '取得したタスクの内容を更新できること' do
        create(:task)

        task = Task.find_by(title: 'Rspec test 0123')
        task.update(status: 'progress')

        updated = Task.find_by(id: task.id)
        expect(updated.status).to eq 'progress'
      end
    end

    context 'タスクの削除' do
      it '取得したタスクを削除できること' do
        create(:task)

        task = Task.find_by(title: 'Rspec test 0123')
        expect(task.destroy.title).to eq 'Rspec test 0123'
      end
    end
  end

  describe 'タスクの取得操作' do
    before do
      (1..10).to_a.each { |i| create(:task, title: "Rspec test #{i}", deadline: "2018/1/#{11 - i} 01:01:01", created_at: "2018/1/1 0:0:#{i}") }
    end

    context '作成時刻順に取得したい場合' do
      it 'created_atの降順で取得できること' do
        task = Task.search(sort: :created_at).first
        expect(task.title).to eq 'Rspec test 10'
      end

      context 'created_atが同一の場合' do
        it 'idの降順で取得できること' do
          task = Task.search(sort: :created_at).first
          expect(task.title).to eq 'Rspec test 10'
        end
      end
    end

    context '期日順に取得したい場合' do
      it 'deadlineの降順で取得できること' do
        task = Task.search(sort: :deadline).first
        expect(task.title).to eq 'Rspec test 1'
      end

      context 'deadlinetが同一の場合' do
        it 'idの降順で取得できること' do
          task = Task.search(sort: :deadline).first
          expect(task.title).to eq 'Rspec test 1'
        end
      end
    end

    context '存在しないカラム名でソート順を指定した場合' do
      it 'デフォルトでcreated_atの降順で取得されること' do
        task = Task.search(sort: :invalid_column).first
        expect(task.title).to eq 'Rspec test 10'
      end
    end
  end

  describe 'enum' do
    context 'statusの場合' do
      it '3つの値が保持されていること' do
        expect(Task.statuses.size).to eq 3
      end

      it '未着手がhashで同一key:val名で存在すること' do
        expect(Task.statuses[:not_start]).to eq 'not_start'
      end

      it '進行中がhashで同一key:val名で存在すること' do
        expect(Task.statuses[:progress]).to eq 'progress'
      end

      it '完了がhashで同一key:val名で存在すること' do
        expect(Task.statuses[:done]).to eq 'done'
      end
    end

    context 'priorityの場合' do
      it '5つの値が保持されていること' do
        expect(Task.priorities.size).to eq 5
      end

      it '低いがhashで同一key:val名で存在すること' do
        expect(Task.priorities[:low]).to eq 'low'
      end

      it '普通がhashで同一key:val名で存在すること' do
        expect(Task.priorities[:normal]).to eq 'normal'
      end

      it '高いがhashで同一key:val名で存在すること' do
        expect(Task.priorities[:high]).to eq 'high'
      end

      it '急いでがhashで同一key:val名で存在すること' do
        expect(Task.priorities[:quickly]).to eq 'quickly'
      end

      it '今すぐがhashで同一key:val名で存在すること' do
        expect(Task.priorities[:right_now]).to eq 'right_now'
      end
    end
  end
end

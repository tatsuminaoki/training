require 'rails_helper'

RSpec.describe Task, type: :model do
  describe 'インスタンスの状態' do
    context '有効な場合' do
      it 'タイトル、期日、ステータス、優先度があれば有効な状態であること' do
        task = build(:task)
        expect(task).to be_valid
      end
    end

    context '無効な場合' do
      it 'タイトルがなければ無効な状態であること' do
        task = build(:task, title: nil)
        expect(task).to be_invalid
      end

      it '期日がなければ無効な状態であること' do
        task = build(:task, deadline: nil)
        expect(task).to be_invalid
      end

      it 'ステータスがなければ無効な状態であること' do
        task = build(:task, status: nil)
        expect(task).to be_invalid
      end

      it '優先度がなければ無効な状態であること' do
        task = build(:task, priority: nil)
        expect(task).to be_invalid
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
        expect(task.status).to eq 'progress' #=> should enum key not array index
        expect(task.priority).to eq 'high' #=> should enum key not array index
      end
    end

    context 'タスクの更新' do
      it '取得したTaskの内容を更新できること' do
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
# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Task, type: :model do
  describe '#save' do
    let(:task) { build(:task, name: 'a' * 1) }

    before do
      task.save
    end

    it 'creates records in task' do
      expect(Task.count).to eq(1)
      expect(task.errors.count).to eq(0)
    end

    context 'nameへの入力がない' do
      let(:task) { build(:task, name: nil) }

      it '必須のエラーメッセージが出ること' do
        expect(Task.count).to eq(0)
        expect(task.errors[:name]).to include('を入力してください')
      end
    end

    context 'nameへ20文字の入力があると' do
      let(:task) { build(:task, name: 'a' * 20) }

      it 'creates records in task' do
        expect(Task.count).to eq(1)
        expect(task.errors.count).to eq(0)
      end
    end

    context 'nameへ21文字以上の入力があると' do
      let(:task) { build(:task, name: 'a' * 21) }

      it '桁数超過のエラーメッセージが出ること' do
        expect(Task.count).to eq(0)
        expect(task.errors[:name]).to include('は20文字以内で入力してください')
      end
    end

    context 'statusへ既定値以外(-1)の入力があると' do
      it 'statusにマイナスの値で永続化できないこと' do
        expect { task.assign_attributes(status: -1) }.to raise_error(ArgumentError)
      end
    end

    context 'statusへ既定値以外(0)の入力があると' do
      it 'statusに0の値で永続化できないこと' do
        expect { task.assign_attributes(status: 0) }.to raise_error(ArgumentError)
      end
    end

    context 'statusへ1(waiting)の入力があると' do
      let(:task) { build(:task, status: :waiting) }

      it 'creates records in task' do
        expect(Task.count).to eq(1)
        expect(task.reload.status).to eq('waiting')
        expect(task.errors.count).to eq(0)
      end
    end

    context 'statusへ2(work_in_progress)の入力があると' do
      let(:task) { build(:task, status: :work_in_progress) }

      it 'creates records in task' do
        expect(Task.count).to eq(1)
        expect(task.reload.status).to eq('work_in_progress')
        expect(task.errors.count).to eq(0)
      end
    end

    context 'statusへ3(completed)の入力があると' do
      let(:task) { build(:task, status: :completed) }

      it 'creates records in task' do
        expect(Task.count).to eq(1)
        expect(task.reload.status).to eq('completed')
        expect(task.errors.count).to eq(0)
      end
    end

    context 'statusへ既定値以外(4)の入力があると' do
      it 'statusに4の値で永続化できないこと' do
        expect { task.assign_attributes(status: 4) }.to raise_error(ArgumentError)
      end
    end
  end
end

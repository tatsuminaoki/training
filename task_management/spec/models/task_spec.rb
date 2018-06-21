require 'rails_helper'

RSpec.describe Task, type: :model do
  describe '#validation' do
    context 'タスク名がnilの場合' do
      let(:task) {Task.new(task_name: nil)}
      it 'バリデーションエラーが発生する' do
        expect(task.validate).to be_falsy
        expect(task.errors).to have_key(:task_name)
        expect(task.errors.full_messages).to eq ['タスク名を入力してください。']
      end
    end

    context 'タスク名が1文字の場合' do
      let(:task) {Task.new(task_name: 'a')}
      it 'バリデーションエラーが発生しない' do
        expect(task.validate).to be_truthy
      end
    end

    context 'タスク名が255文字の場合' do
      let(:task) {Task.new(task_name: 'a'*255)}
      it 'バリデーションエラーが発生しない' do
        expect(task.validate).to be_truthy
      end
    end

    context 'タスク名が256文字の場合' do
      let(:task) {Task.new(task_name: 'a'*256)}
      it 'バリデーションエラーが発生する' do
        expect(task.validate).to be_falsy
        expect(task.errors).to have_key(:task_name)
        expect(task.errors.full_messages).to eq ['タスク名は255字以内で入力してください。']
      end
    end
  end
end

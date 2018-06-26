require 'rails_helper'

RSpec.describe Task, type: :model do
  describe '#validation' do
    context 'タスク名が0文字の場合' do
      let(:task) {Task.new(task_name: '', due_date: Date.today)}
      it 'バリデーションエラーが発生する' do
        expect(task.validate).to be_falsy
        expect(task.errors).to have_key(:task_name)
        expect(task.errors.full_messages).to eq ['タスク名を入力してください。']
      end
    end

    context 'タスク名が1文字の場合' do
      let(:task) {Task.new(task_name: 'a', due_date: Date.today)}
      it 'バリデーションエラーが発生しない' do
        expect(task.validate).to be_truthy
      end
    end

    context 'タスク名が255文字の場合' do
      let(:task) {Task.new(task_name: 'a'*255, due_date: Date.today)}
      it 'バリデーションエラーが発生しない' do
        expect(task.validate).to be_truthy
      end
    end

    context 'タスク名が256文字の場合' do
      let(:task) {Task.new(task_name: 'a'*256, due_date: Date.today)}
      it 'バリデーションエラーが発生する' do
        expect(task.validate).to be_falsy
        expect(task.errors).to have_key(:task_name)
        expect(task.errors.full_messages).to eq ['タスク名は255字以内で入力してください。']
      end
    end
    
    context '期限を入力しない場合' do
      let(:task) {Task.new(task_name: 'a', due_date: '')}
      it 'バリデーションエラーが発生しない' do
        expect(task.validate).to be_truthy
      end
    end

    context '期限が存在しない日付の場合' do
      let(:task) {Task.new(task_name: 'a', due_date: '2018-06-31')}
      it 'バリデーションエラーが発生する' do
        expect(task.validate).to be_falsy
        expect(task.errors).to have_key(:due_date)
        expect(task.errors.full_messages).to eq ['期限を正しく入力してください。']
      end
    end
    context 'タスク名が0文字かつ期限が存在しない日付の場合' do
      let(:task) {Task.new(task_name: '', due_date: '2018-06-31')}
      it 'バリデーションエラーが複数発生する' do
        expect(task.validate).to be_falsy
        expect(task.errors).to have_key(:task_name)
        expect(task.errors).to have_key(:due_date)
        expect(task.errors.full_messages).to eq ['タスク名を入力してください。', '期限を正しく入力してください。']
      end
    end
  end
end

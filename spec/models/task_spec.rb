require 'rails_helper'

RSpec.describe Task, type: :model do
  describe 'valid?' do
    let(:task) { create(:task) }

    context 'タイトルと詳細がある場合' do
      it 'タスクが正常に作成される' do
        expect(task).to be_valid
      end
    end

    context 'タイトルと詳細がない場合' do
      it 'タスクの作成に失敗する' do
        task = build(:task, title: nil, detail: nil)
        expect(task).to be_invalid
      end
    end

    context 'タイトルに問題がある場合' do
      context 'タイトルがない場合' do
        it 'タスクの作成に失敗する' do
          task = build(:task, title: nil)
          expect(task).to be_invalid
        end
      end
      context 'title < 255 の場合' do
        it 'タスク作成に成功する' do
          task = build(:task, title: 'a' * 254)
          expect(task).to be_valid
        end
      end
      context 'title = 255 の場合' do
        it 'タスク作成に成功する' do
          task = build(:task, title: 'a' * 255)
          expect(task).to be_valid
        end
      end
      context 'title > 255 の場合' do
        it ' タスク作成に失敗する' do
          task = build(:task, title: 'a' * 256)
          expect(task).to be_invalid
        end
      end
    end

    context '詳細に問題がある場合' do
      context '詳細がない場合' do
        it 'タスクの作成に失敗する' do
          task = build(:task, title: nil)
          expect(task).to be_invalid
        end
      end
      context 'detail < 255 の場合' do
        it ' タスク作成に成功する' do
          task = build(:task, detail: 'a' * 254)
          expect(task).to be_valid
        end
      end
      context 'detail = 255 の場合' do
        it ' タスク作成に成功する' do
          task = build(:task, detail: 'a' * 255)
          expect(task).to be_valid
        end
      end
      context 'detail > 255 の場合' do
        it 'タスク作成に失敗する' do
          task = build(:task, detail: 'a' * 256)
          expect(task).to be_invalid
        end
      end
    end
  end
end

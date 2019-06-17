require 'rails_helper'

RSpec.describe Task, type: :model do
  describe 'valid?' do
    let(:task) { create(:task) }

    context 'タイトルと詳細とステータスがある場合' do
      it 'タスクが正常に作成される' do
        expect(task).to be_valid
      end
    end

    context 'タイトルと詳細とステータスがない場合' do
      it 'タスクの作成に失敗する' do
        task = build(:task, title: nil, detail: nil, status: nil)
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

    context 'ステータスに問題がある場合' do
      context 'ステータスがない場合' do
        it 'タスクの作成に失敗する' do
          task = build(:task, status: nil)
          expect(task).to be_invalid
        end
      end
      context 'ステータスをintegerで入れた場合' do
        it 'タスク作成に成功する' do
          task = build(:task, status: 1)
          expect(task).to be_valid
        end
      end
      context 'ステータスが規定値[todo,doing,done]以外の場合' do
        it 'ArgumentErrorが発生する' do
          expect { build(:task, status: 9) }.to raise_error(ArgumentError)
        end
      end
    end
  end

  describe '#search' do
    before do
      create(:task, title: 'hoge1', status: 0)
      create(:task, title: 'hoge2', status: 1)
      create(:task, title: 'hoge3', status: 2)
    end

    context 'タイトルで検索する' do
      it 'タイトルが存在すればヒットする' do
        expect(Task.search(title: 'hoge1').count).to eq 1
      end
      it 'タイトルが存在しなければヒットしない' do
        expect(Task.search(title: 'hoge9').count).to eq 0
      end
    end
    context 'ステータスで検索する' do
      it 'ステータスが存在すればヒットする' do
        expect(Task.search(status: 0).count).to eq 1
      end
      it 'ステータスが存在しなければヒットしない' do
        expect(Task.search(status: 9).count).to eq 0
      end
    end
    context 'タイトルとステータスで検索する' do
      it 'タイトルとステータスの組み合わせが存在すればヒットする' do
        expect(Task.search(title: 'hoge1', status: 0).count).to eq 1
      end
      it 'タイトルとステータスの組み合わせが存在しなければヒットしない' do
        expect(Task.search(title: 'hoge1', status: 1).count).to eq 0
      end
    end
  end
end

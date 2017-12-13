require 'rails_helper'

RSpec.describe Task, type: :model do
  describe 'validation' do
    describe 'name' do
      let!(:task) { FactoryBot.build(:task, name: name) }
      subject { task.valid? }

      context '入力が正しい場合' do
        let(:name) { 'test' }
        it { is_expected.to be true }
      end

      context '空欄の場合' do
        let(:name) { '' }
        it { is_expected.to be false }
      end

      context '文字列の長さ' do
        context '254以下の場合' do
          let(:name) { 'a' * 254 }
          it { is_expected.to be true }
        end

        context '255の場合' do
          let(:name) { 'a' * 255 }
          it { is_expected.to be true }
        end

        context '256以上の場合' do
          let(:name) { 'a' * 256 }
          it { is_expected.to be false }
        end
      end
    end

    describe 'user_id' do
      let(:task) { FactoryBot.build(:task, user_id: user_id) }
      subject { task.valid? }

      # TODO : User機能実装時にIDが存在することを検証する
      context '入力が正しい場合' do
        let(:user_id) { 1 }
        it { is_expected.to be true }
      end

      context '空欄の場合' do
        let(:user_id) { '' }
        it { is_expected.to be false }
      end

      context '数値でない場合' do
        let(:user_id) { 'abc' }
        it { is_expected.to be false }
      end

      context '負の数値の場合' do
        let(:user_id) { -1 }
        it { is_expected.to be false }
      end
    end

    describe 'priority' do
      let(:task) { FactoryBot.build(:task, priority: priority) }
      subject { task.valid? }

      context '入力が正しい場合' do
        let(:priority) { 1 }
        it { is_expected.to be true }
      end

      context '空欄の場合' do
        let(:priority) { '' }
        it { is_expected.to be false }
      end

      context '数値でない場合' do
        let(:priority) { 'abc' }
        it { expect { subject }.to raise_error(ArgumentError) }
      end

      context '負の数値の場合' do
        let(:priority) { -1 }
        it { expect { subject }.to raise_error(ArgumentError) }
      end
    end

    describe 'status' do
      let(:task) { FactoryBot.build(:task, status: status) }
      subject { task.valid? }

      context '入力が正しい場合' do
        let(:status) { 1 }
        it { is_expected.to be true }
      end

      context '空欄の場合' do
        let(:status) { '' }
        it { is_expected.to be false }
      end

      context '数値でない場合' do
        let(:status) { 'abc' }
        it { expect { subject }.to raise_error(ArgumentError) }
      end

      context '負の数値の場合' do
        let(:status) { -1 }
        it { expect { subject }.to raise_error(ArgumentError) }
      end
    end

    describe 'label_id' do
      let(:task) { FactoryBot.build(:task, label_id: label_id) }
      subject { task.valid? }

      context '入力が正しい場合' do

        # TODO : Label機能実装時にIDが存在することを検証する
        context '数値が設定されている場合' do
          let(:label_id) { 1 }
          it { is_expected.to be true }
        end

        context '空欄の場合' do
          let(:label_id) { '' }
          it { is_expected.to be true }
        end
      end

      context '数値でない場合' do
        let(:label_id) { 'abc' }
        it { is_expected.to be false }
      end

      context '負の数値の場合' do
        let(:label_id) { -1 }
        it { is_expected.to be false }
      end
    end

    describe 'end_date' do
      let(:task) { FactoryBot.build(:task, end_date: end_date) }
      subject { task.valid? }

      context '入力が正しい場合' do
        context '日付が設定されている場合' do
          let(:end_date) { '2017-01-01' }
          it { is_expected.to be true }
        end

        context '空欄の場合' do
          let(:end_date) { '' }
          it { is_expected.to be true }
        end
      end

      context '日付でない場合' do
        context '数値の場合' do
          let(:end_date) { 123 }
          it { is_expected.to be false }
        end

        context '文字列の場合' do
          let(:end_date) { 'abc' }
          it { is_expected.to be false }
        end
      end

      context '存在しない日付の場合' do
        let(:end_date) { '2017-2-31' }
        it { is_expected.to be false }
      end
    end
  end

  describe '#search' do
    subject { Task.search(params) }

    context '検索ロジック' do
      context 'ステータス検索' do
        let!(:task_0) { FactoryBot.create(:task, status: 0, created_at: '2017-01-03') }
        let!(:task_1) { FactoryBot.create(:task, status: 1, created_at: '2017-01-02') }
        let!(:task_2) { FactoryBot.create(:task, status: 2, created_at: '2017-01-01') }

        context '指定しない場合' do
          let(:params) { {} }
          it '全てのタスクが出力される' do
            expect(subject[0]).to eq task_0
            expect(subject[1]).to eq task_1
            expect(subject[2]).to eq task_2
          end
        end

        context '未着手の場合' do
          let(:params) { { status: 0 } }
          it '未着手のタスクが絞り込まれる' do
            expect(subject[0]).to eq task_0
            expect(subject[1]).to be nil
            expect(subject[2]).to be nil
          end
        end

        context '着手中の場合' do
          let(:params) { { status: 1 } }
          it '着手中のタスクが絞り込まれる' do
            expect(subject[0]).to eq task_1
            expect(subject[1]).to be nil
            expect(subject[2]).to be nil
          end
        end

        context '完了の場合' do
          let(:params) { { status: 2 } }
          it '完了のタスクが絞り込まれる' do
            expect(subject[0]).to eq task_2
            expect(subject[1]).to be nil
            expect(subject[2]).to be nil
          end
        end
      end

      context 'タスク名検索' do
        let!(:task_0) { FactoryBot.create(:task, name: 'hoge', created_at: '2017-01-02') }
        let!(:task_1) { FactoryBot.create(:task, name: 'fuga', created_at: '2017-01-01') }

        context '指定しない場合' do
          let(:params) { {} }
          it '全てのタスクが出力される' do
            expect(subject[0]).to eq task_0
            expect(subject[1]).to eq task_1
          end
        end

        context '指定した場合' do
          let(:params) { { name: 'hoge' } }
          it '全てのタスクが出力される' do
            expect(subject[0]).to eq task_0
            expect(subject[1]).to be nil
          end
        end
      end
    end

    context 'ソートロジック' do
      let!(:task_0) { FactoryBot.create(:task, end_date: '2017-02-02', created_at: '2017-01-02') }
      let!(:task_1) { FactoryBot.create(:task, end_date: '2017-02-01', created_at: '2017-01-01') }

      context '指定しない場合' do
        let(:params) { {} }
        it '作成日時の降順ソートになる' do
          expect(subject[0]).to eq task_0
          expect(subject[1]).to eq task_1
        end
      end

      context '終了期限ソートの場合' do
        context '昇順' do
          let(:params) { { order: 'end_date_asc' } }
          it '終了期限の昇順ソートになる' do
            expect(subject[0]).to eq task_1
            expect(subject[1]).to eq task_0
          end
        end

        context '降順' do
          let(:params) { { order: 'end_date_desc' } }
          it '終了期限の降順ソートになる' do
            expect(subject[0]).to eq task_0
            expect(subject[1]).to eq task_1
          end
        end
      end
    end
  end
end

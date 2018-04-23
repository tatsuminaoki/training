require 'rails_helper'

RSpec.describe Task, type: :model do
  describe 'validation' do
    let!(:user) { FactoryBot.create(:user) }
    it 'has a valid factory' do
      expect(FactoryBot.build(:task)).to be_valid
    end

    it 'is invalid without タイトル' do
      task = FactoryBot.build(:task, title: nil)
      task.valid?
      expect(task.errors[:title]).to include('を入力してください')
    end

    it 'is invalid without 終了期限' do
      task = FactoryBot.build(:task, due_date: nil)
      task.valid?
      expect(task.errors[:due_date]).to include('を入力してください')
    end

    it 'is invalid without 優先度' do
      task = FactoryBot.build(:task, priority: nil)
      task.valid?
      expect(task.errors[:priority]).to include('を入力してください')
    end

    it 'is valid with numericality to 優先度' do
      task = FactoryBot.build(:task, priority: '低い')
      task.valid?
      expect(task.errors[:priority]).to include('は数値で入力してください')
    end

    it 'is invalid with specific range to 優先度' do
      task = FactoryBot.build(:task, priority: 3)
      task.valid?
      expect(task.errors[:priority]).to include('は2以下の値にしてください')
    end

    it 'is invalid with specific range to 優先度' do
      task = FactoryBot.build(:task, priority: -1)
      task.valid?
      expect(task.errors[:priority]).to include('は0以上の値にしてください')
    end

    it 'is invalid without ステータス' do
      task = FactoryBot.build(:task, status: nil)
      task.valid?
      expect(task.errors[:status]).to include('を入力してください')
    end

    it 'is valid with numericality to ステータス' do
      task = FactoryBot.build(:task, status: '未着手')
      task.valid?
      expect(task.errors[:status]).to include('は数値で入力してください')
    end

    it 'is invalid with specific range to ステータス' do
      task = FactoryBot.build(:task, status: 4)
      task.valid?
      expect(task.errors[:status]).to include('は2以下の値にしてください')
    end

    it 'is invalid with specific range to ステータス' do
      task = FactoryBot.build(:task, status: -2)
      task.valid?
      expect(task.errors[:status]).to include('は0以上の値にしてください')
    end

    it 'is invalid without 作成ユーザー' do
      task = FactoryBot.build(:task, user_id: nil)
      task.valid?
      expect(task.errors[:user_id]).to include('を入力してください')
    end

    it 'is valid with numericality to 作成ユーザー' do
      task = FactoryBot.build(:task, user_id: 'test_user')
      task.valid?
      expect(task.errors[:user_id]).to include('は数値で入力してください')
    end

    it 'is invalid with specific range to 作成ユーザー' do
      task = FactoryBot.build(:task, user_id: -3)
      task.valid?
      expect(task.errors[:user_id]).to include('は0より大きい値にしてください')
    end
  end

  describe '#search' do
    let!(:user) { FactoryBot.create(:user) }
    subject { Task.includes(:user).search(params, user.id) }

    context 'search feature' do
      context 'In case of ステータス検索' do
        let!(:task_0) { FactoryBot.create(:task, status: 0, created_at: Time.current) }
        let!(:task_1) { FactoryBot.create(:task, status: 1, created_at: 1.day.since) }
        let!(:task_2) { FactoryBot.create(:task, status: 2, created_at: 2.days.since) }

        context 'non status' do
          let(:params) { {} }
          it 'shows all tasks with created_at desc' do
            expect(subject[0]).to eq task_2
            expect(subject[1]).to eq task_1
            expect(subject[2]).to eq task_0
          end
        end

        context '未着手' do
          let(:params) { { status: 0 } }
          it 'shows only 未着手 status' do
            expect(subject[0]).to eq task_0
            expect(subject[1]).to eq nil
            expect(subject[2]).to eq nil
          end
        end

        context '進行中' do
          let(:params) { { status: 1 } }
          it 'shows only 進行中 status' do
            expect(subject[0]).to eq task_1
            expect(subject[1]).to eq nil
            expect(subject[2]).to eq nil
          end
        end

        context '完了' do
          let(:params) { { status: 2 } }
          it 'shows only 完了 status' do
            expect(subject[0]).to eq task_2
            expect(subject[1]).to eq nil
            expect(subject[2]).to eq nil
          end
        end
      end

      context 'In case of title search' do
        let!(:task_0) { FactoryBot.create(:task, title: 'Test Task 1', created_at: Time.current) }
        let!(:task_1) { FactoryBot.create(:task, title: 'Test Task 2', created_at: 1.day.since) }

        context 'non title' do
          let(:params) { {} }
          it 'shows all tasks with created_at desc' do
            expect(subject[0]).to eq task_1
            expect(subject[1]).to eq task_0
          end
        end

        context 'designating title' do
          let(:params) { { title: '1' } }
          it 'shows only target task' do
            expect(subject[0]).to eq task_0
            expect(subject[1]).to eq nil
          end
        end
      end
    end

    context 'order feature' do
      let!(:task_0) { FactoryBot.create(:task, due_date: Time.current, priority: 0, created_at: Time.current) }
      let!(:task_1) { FactoryBot.create(:task, due_date: 1.day.since.to_date, priority: 1, created_at: 1.day.since) }
      let!(:task_2) { FactoryBot.create(:task, due_date: 2.days.since.to_date, priority: 2, created_at: 2.days.since) }

      context 'non sort' do
        let(:params) { {} }
        it 'shows tasks with created_at desc' do
          expect(subject[0]).to eq task_2
          expect(subject[1]).to eq task_1
          expect(subject[2]).to eq task_0
        end
      end

      context 'In case of due_date sort ' do
        context 'In case of 降順' do
        let(:params) { { due_date_desc: 'true' } }
          it 'shows tasks with due_date desc' do
            expect(subject[0]).to eq task_2
            expect(subject[1]).to eq task_1
            expect(subject[2]).to eq task_0
          end
        end

        context 'In case of 昇順' do
        let(:params) { { due_date_desc: 'false' } }
          it 'shows tasks with due_date asc' do
            expect(subject[0]).to eq task_0
            expect(subject[1]).to eq task_1
            expect(subject[2]).to eq task_2
          end
        end
      end

      context 'In case of priority sort ' do
        context 'In case of 降順' do
        let(:params) { { priority_desc: 'true' } }
          it 'shows tasks with priority desc' do
            expect(subject[0]).to eq task_2
            expect(subject[1]).to eq task_1
            expect(subject[2]).to eq task_0
          end
        end

        context 'In case of 昇順' do
        let(:params) { { priority_desc: 'false' } }
          it 'shows tasks with priority asc' do
            expect(subject[0]).to eq task_0
            expect(subject[1]).to eq task_1
            expect(subject[2]).to eq task_2
          end
        end
      end
    end
  end
end

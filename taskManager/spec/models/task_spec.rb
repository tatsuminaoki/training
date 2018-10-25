require 'rails_helper'

RSpec.describe Task, type: :model do
  describe 'タスク登録テスト' do
    subject { task.valid? }
    context '妥当なタスクの時' do
      let(:task) { FactoryBot.build(:task) }
      it "タスク名、説明、ユーザID、優先度があれば有効な状態であること" do
        is_expected.to be_truthy
      end
    end
    context 'タスク名が無い時' do
      let(:task) { FactoryBot.build(:task, task_name: nil) }
      it "タスク名が無ければ、無効な状態であること" do
        is_expected.to be_falsey
      end
    end
    context '説明が無い時' do
      let(:task) { FactoryBot.build(:task, description: nil) }
      it "説明が無ければ、無効な状態であること" do
        is_expected.to be_falsey
      end
    end
    context 'ユーザIDが無い時' do
      let(:task) { FactoryBot.build(:task, user_id: nil) }
      it "ユーザIDが無ければ、無効な状態であること" do
        is_expected.to be_falsey
      end
    end
    context '優先度が無い時' do
      let(:task) { FactoryBot.build(:task, priority: nil) }
      it "優先度が無ければ、無効な状態であること" do
        is_expected.to be_falsey
      end
    end
    context 'ステータスが無い時' do
      let(:task) { FactoryBot.build(:task, status: nil) }
      it "ステータスが無ければ、無効な状態であること" do
        is_expected.to be_falsey
      end
    end
    context 'ユーザIDが存在しない時' do
      let(:user) { FactoryBot.create(:user) }
      let(:task) { FactoryBot.create(:task, user_id: user.id + 100) }
      it "ユーザIDが存在しなければ、無効な状態であること" do
        expect { subject }.to raise_error(ActiveRecord::RecordInvalid)
      end
    end
  end
  describe 'タスク検索テスト' do
    # TODO: 検索機能が現状ないので後で実装する
    context "検索関連テスト(１項目)" do
      it "全件検索ができる"
      it "タスク名検索ができる"
      it "説明検索ができる"
      it "期限で検索ができる"
      it "優先度で検索ができる"
      it "ステータスで検索ができる"
      it "1つのラベルで検索ができる"
      it "複数件のラベルで検索ができる"
    end
    context "登録日時(降順の検索)" do
      let(:user) { FactoryBot.create(:user) }

      # order by created_at descの場合(task2 -> task3 -> task1の順番になるはず)
      let(:task1) { FactoryBot.create(:task, user_id: user.id, created_at: "2018-05-20 14:00:00") }
      let(:task2) { FactoryBot.create(:task, user_id: user.id, created_at: "2018-05-21 15:00:00") }
      let(:task3) { FactoryBot.create(:task, user_id: user.id, created_at: "2018-05-20 14:02:00") }
      it "登録日時の降順で検索できること(STEP10)の課題" do
        expect(Task.all).to eq [task2, task3, task1]
      end
    end
    context "検索関連テスト(複数項目)" do
      it "タスク名とステータスで検索ができる"
      it "説明と期限で検索ができる"
      it "優先度とラベルで検索ができる"
    end
  end
end

require 'rails_helper'

RSpec.describe Task, type: :model do
  describe 'タスク範囲テスト' do
    it "優先度のenum設定が(low common high)のみ有効な状態であること" do
      should define_enum_for(:priority).with(%w[low common high])
    end
    it "ステータスのenum設定が(waiting working completed)のみ有効な状態であること" do
      should define_enum_for(:status).with(%w[waiting working completed])
    end
  end
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
    context 'タスク名(半角255文字以内)' do
      let(:task) { FactoryBot.build(:task, task_name: 'a' * 255) }
      it "タスク名文字数 = 255文字の場合有効であること(半角文字)" do
        is_expected.to be_truthy
      end
    end
    context 'タスク名(全角255文字以内)' do
      let(:task) { FactoryBot.build(:task, task_name: 'あ' * 255) }
      it "タスク名文字数 = 255文字の場合有効であること(全角文字)" do
        is_expected.to be_truthy
      end
    end
    context 'タスク名(>半角255文字)' do
      let(:task) { FactoryBot.build(:task, task_name: 'a' * 256) }
      it "タスク名文字数 > 255文字の場合エラー(半角文字)" do
        is_expected.to be_falsey
      end
    end
    context 'タスク名(>全角255文字)' do
      let(:task) { FactoryBot.build(:task, task_name: 'あ' * 256) }
      it "タスク名文字数 > 255文字の場合エラー(全角文字)" do
        is_expected.to be_falsey
      end
    end
    context '説明が無い時' do
      let(:task) { FactoryBot.build(:task, description: nil) }
      it "説明が無ければ、無効な状態であること" do
        is_expected.to be_falsey
      end
    end
    context '説明文(半角20_000文字以内)' do
      let(:task) { FactoryBot.build(:task, description: 'a' * 20_000) }
      it "説明文字数 = 20_000文字の場合有効であること(半角文字)" do
        is_expected.to be_truthy
      end
    end
    context '説明文(全角20_000文字以内)' do
      let(:task) { FactoryBot.build(:task, description: 'あ' * 20_000) }
      it "説明文字数 = 20_000文字の場合有効であること(全角文字)" do
        is_expected.to be_truthy
      end
    end
    context '説明文(>半角20_000文字)' do
      let(:task) { FactoryBot.build(:task, description: 'a' * 20_001) }
      it "説明文字数 > 20_000文字の場合エラー(半角文字)" do
        is_expected.to be_falsey
      end
    end
    context '説明文(>全角20_000文字)' do
      let(:task) { FactoryBot.build(:task, description: 'あ' * 20_001) }
      it "説明文字数 > 20_000文字の場合エラー(全角文字)" do
        is_expected.to be_falsey
      end
    end
    context 'ユーザIDが無い時' do
      let(:task) { FactoryBot.build(:task, user_id: nil) }
      it "ユーザIDが無ければ、無効な状態であること" do
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

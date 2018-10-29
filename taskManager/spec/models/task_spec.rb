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
    let(:user) { user = FactoryBot.create(:user) }
    let!(:task1) {
      FactoryBot.create(:task, task_name: 'task1', user_id: user.id, status: :waiting, created_at: '2018-05-20 14:00:00')
    }
    let!(:task2) {
      FactoryBot.create(:task, task_name: 'task2', user_id: user.id, status: :waiting, created_at: '2018-05-21 15:00:00')
    }
    let!(:task3) {
      FactoryBot.create(:task, task_name: 'task3', user_id: user.id, status: :waiting, created_at: '2018-05-20 14:02:00')
    }
    let!(:task4) {
      FactoryBot.create(:task, task_name: 'task4', user_id: user.id, status: :waiting, deadline: "2018-05-20 14:00:00", created_at: "2018-05-04 10:11:10")
    }
    let!(:task5) {
      FactoryBot.create(:task, task_name: 'task5', user_id: user.id, status: :completed ,deadline: nil, created_at: "2018-04-01 10:00:00")
    }
    let!(:task6) {
      FactoryBot.create(:task, task_name: 'task6', user_id: user.id, status: :waiting, deadline: "2018-05-19 14:00:00", created_at: "2018-05-10 10:03:04")
    }
    let!(:task7) {
      FactoryBot.create(:task, task_name: 'task7', user_id: user.id, status: :working, deadline: nil, created_at: "2018-10-21 15:00:00")
    }
    let!(:task8) {
      FactoryBot.create(:task, task_name: 'task8', user_id: user.id, status: :working, deadline: "2018-04-10 10:11:21", created_at: "2018-05-21 15:00:00")
    }
    let!(:task9) {
      FactoryBot.create(:task, task_name: 'task9', user_id: user.id, status: :completed, deadline: nil, created_at: "2018-05-20 14:02:00")
    }
    context "検索関連テスト(１項目)"
    context "全件検索ができる"
    context "タスク名で検索" do
      let(:params) do
        { task_name: "task1" }
      end
      it "タスク名検索ができる" do
        expect(Task.search(params)).to eq [task1]
      end
    end
    context "説明検索ができる"
    context "期限で検索ができる"
    context "優先度で検索ができる"
    context "ステータス検索" do
      let(:params) do { status: :working } end
      it "ステータスで検索ができる" do
        expect(Task.search(params)).to eq [task7, task8]
      end
    end
    context "1つのラベルで検索ができる"
    context "複数件のラベルで検索ができる"
    context "タスク名とステータスで検索" do
      let!(:task10) { FactoryBot.create(:task, task_name: "テスト10", user_id: user.id, status: :working, deadline: "2018-04-10 10:11:21", created_at: "2018-05-21 15:00:00") }
      let!(:task11) { FactoryBot.create(:task, task_name: "テスト11", user_id: user.id, status: :working, deadline: nil, created_at: "2018-05-20 14:02:00") }
      let(:params) do { status: :working, task_name: "テスト" } end
      it "タスク名とステータスで検索ができる" do
        expect(Task.search(params)).to eq [task10, task11]
      end
    end
    context "説明と期限で検索ができる"
    context "優先度とラベルで検索ができる"
    context "検索関連テスト(１項目)"
    context "説明検索ができる"
    context "優先度で検索ができる"
    context "ステータスで検索ができる"
    context "1つのラベルで検索ができる"
    context "複数件のラベルで検索ができる"
    context "検索関連テスト(複数項目)"
    context "タスク名とステータスで検索ができる"
    context "説明と期限で検索ができる"
    context "優先度とラベルで検索ができる"
  end
end

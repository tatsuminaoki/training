require 'rails_helper'

RSpec.describe Task, type: :model do
  context '登録テスト' do
    it "タスク名、説明、ユーザID、優先度があれば有効な状態であること" do
      expect(FactoryBot.build(:task)).to be_valid
    end
    it "タスク名が無ければ、無効な状態であること" do
      task = FactoryBot.build(:task, task_name: nil)
      task.valid?
      expect(task.errors[:task_name]).to include("can't be blank")
    end
    it "説明が無ければ、無効な状態であること" do
      task = FactoryBot.build(:task, description: nil)
      task.valid?
      expect(task.errors[:description]).to include("can't be blank")
    end
    it "ユーザIDが無ければ、無効な状態であること" do
      task = FactoryBot.build(:task, user_id: nil)
      task.valid?
      expect(task.errors[:user_id]).to include("can't be blank")
    end
    it "優先度が無ければ、無効な状態であること" do
      task = FactoryBot.build(:task, priority: nil)
      task.valid?
      expect(task.errors[:priority]).to include("can't be blank")
    end
    it "ステータスが無ければ、無効な状態であること" do
      task = FactoryBot.build(:task, status: nil)
      task.valid?
      expect(task.errors[:status]).to include("can't be blank")
    end
    it "ユーザIDが存在しなければ、無効な状態であること" do
      user = FactoryBot.create(:user)
      expect do
        FactoryBot.create(:task, user_id: user.id + 100)
      end.to raise_error(ActiveRecord::RecordInvalid)
    end
  end
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
  context "検索関連テスト(複数項目)" do
    it "タスク名とステータスで検索ができる"
    it "説明と期限で検索ができる"
    it "優先度とラベルで検索ができる"
  end
end

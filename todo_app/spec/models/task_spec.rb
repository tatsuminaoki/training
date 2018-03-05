require 'rails_helper'

RSpec.describe Task, type: :model do
  # タイトル、期日、ステータス、優先度があれば有効な状態であること
  it "is valid with a title, deadline, status and priority" do
    task = FactoryBot.create(:task)
    expect(task).to be_valid
  end

  # Taskを1件登録できること
  it "can regist one task" do
    task = FactoryBot.create(:task)
    expect(task.save).to eq true
  end

  # 必須項目を指定しない場合、エラーになること
  # TODO validationを作成したらテストを追加する
  it "return error if required item is null"

  # 登録した値を取得できること
  it "can select registered task" do
    task = FactoryBot.create(:task)
    task.save

    registered = Task.find_by(title: "Rspec test 0123")
    expect(registered.title).to eq "Rspec test 0123"
  end

  # 取得したTaskの内容を更新できること
  it "can update registered task" do
    task = FactoryBot.create(:task)
    task.save

    registered = Task.find_by(title: "Rspec test 0123")
    expect(registered.update(status:  "START")).to eq true
  end

  # 取得したTaskを削除できること
  it "can delete registered task" do
    task = FactoryBot.create(:task)
    task.save

    registered = Task.find_by(title: "Rspec test 0123")
    expect(registered.destroy.title).to eq "Rspec test 0123"
  end
end

require 'rails_helper'

RSpec.describe Task, type: :model do
  # タイトル、期日、ステータス、優先度があれば有効な状態であること
  it "is valid with a title, deadline, status and priority" do
    task = build(:task)
    expect(task).to be_valid
  end

  # タイトルがなければ無効な状態であること
  it "is invalid without a title" do
    task = build(:task, title: nil)
    expect(task).to be_invalid
  end

  # 期日がなければ無効な状態であること
  it "is invalid without a deadline" do
    task = build(:task, deadline: nil)
    expect(task).to be_invalid
  end

  # ステータスがなければ無効な状態であること
  it "is invalid without a status" do
    task = build(:task, status: nil)
    expect(task).to be_invalid
  end

  # 優先度がなければ無効な状態であること
  it "is invalid without a priority" do
    task = build(:task, priority: nil)
    expect(task).to be_invalid
  end

  # Taskを1件登録できること
  it "can register one task" do
    expect(Task.create(attributes_for(:task))).to be_truthy
    expect(Task.count).to eq 1
  end

  # 登録した値を取得できること
  it "can select registered task" do
    create(:task)

    task = Task.find_by(title: "Rspec test 0123")
    expect(task.title).to eq "Rspec test 0123"
  end

  # 取得したTaskの内容を更新できること
  it "can update registered task" do
    create(:task)

    task = Task.find_by(title: "Rspec test 0123")
    task.update(status:  "START")

    updated = Task.find_by(id: task.id)
    expect(updated.status).to eq "START"
  end

  # 取得したTaskを削除できること
  it "can delete registered task" do
    create(:task)

    task = Task.find_by(title: "Rspec test 0123")
    expect(task.destroy.title).to eq "Rspec test 0123"
  end
end

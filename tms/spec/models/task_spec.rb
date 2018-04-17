require 'rails_helper'

RSpec.describe Task, type: :model do
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

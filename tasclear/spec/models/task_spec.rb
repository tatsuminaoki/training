# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Task, type: :model do
  it 'タスク名と内容があれば有効な状態であること' do
    task = Task.new(
      name: '家事',
      content: '掃除、洗濯',
    )
    expect(task).to be_valid
  end
  it 'タスク名がなければ無効な状態であること' do
    task = Task.new(
      name: '',
      content: '掃除、洗濯',
    )
    expect(task).to be_invalid
  end
  it 'タスク名が20文字であれば有効な状態であること' do
    task = Task.new(
      name: 'あ' * 20,
      content: '掃除、洗濯',
    )
    expect(task).to be_valid
  end
  it 'タスク名が21文字であれば無効な状態であること' do
    task = Task.new(
      name: 'あ' * 21,
      content: '掃除、洗濯',
    )
    expect(task).to be_invalid
  end
  it '内容が200文字であれば有効な状態であること' do
    task = Task.new(
      name: '家事',
      content: 'あ' * 200,
    )
    expect(task).to be_valid
  end
  it '内容が201文字であれば無効な状態であること' do
    task = Task.new(
      name: '家事',
      content: 'あ' * 201,
    )
    expect(task).to be_invalid
  end
end

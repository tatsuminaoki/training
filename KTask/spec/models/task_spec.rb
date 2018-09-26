# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Task, type: :model do
  it 'タスクの有効性検査' do
    task = Task.new(
    title: 'spec test',
    content: 'this is spec test',
    status: 1,
    )
    expect(task).to be_valid
  end
  it 'タスクのタイトル空白検査' do
    task = Task.new(title: '', content: 'title validation test', status: 0)
    expect(task).not_to be_valid
  end
  it 'タイトル文字の制限テスト' do
    test_title = ''
    for i in 0..21 do
      test_title += 'あ'
    end
    task = Task.new(title: test_title, content: 'this is validation test', status: 0)
    expect(task).not_to be_valid
  end
  it 'タスクの内容空白検査' do
    task = Task.new(title: 'test', content: '', status: 2)
    expect(task).not_to be_valid
  end
  it 'タスクの状態空白検査' do
    task = Task.new(title: 'test', content: 'status validation test', status: '')
    expect(task).not_to be_valid
  end
end

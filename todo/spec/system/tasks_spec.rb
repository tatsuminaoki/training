# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Tasks', type: :system do
  let(:task) { Task.create(title: 'タスク１', description: 'タスク１詳細', status: 0) }

  it 'show tasks ordered by latest dates' do
    visit tasks_new_path
    fill_in 'task_title', with: 'first'
    click_button '追加'

    visit tasks_new_path
    fill_in 'task_title', with: 'second'
    click_button '追加'

    within('ul') do
      expect(page.text).to match(/second\nfirst/)
    end
  end

  it 'show task detail' do
    visit tasks_show_path(task)

    expect(page).to have_content 'タスク１'
    expect(page).to have_content 'タスク１詳細'
    expect(page).to have_content '未着手'
  end

  it 'create new task' do
    visit tasks_new_path

    fill_in 'task_title', with: '新規タスク'
    fill_in 'task_description', with: '新規タスク詳細'
    select '着手', from: 'task_status'

    click_button '追加'

    expect(page).to have_content 'Success!'
    expect(page).to have_content '新規タスク'
  end

  it 'update task' do
    visit tasks_edit_path(task)

    expect(page).to have_field 'task_title', with: 'タスク１'
    expect(page).to have_field 'task_description', with: 'タスク１詳細'
    expect(page).to have_select 'task_status',
                                selected: '未着手',
                                options: %w[未着手 着手 完了]

    fill_in 'task_title', with: 'タスク１修正'
    fill_in 'task_description', with: 'タスク１詳細修正'
    select '完了', from: 'task_status'

    click_button '更新'

    expect(page).to have_content 'Success!'
    expect(page).to have_content 'タスク１修正'
  end

  it 'delete task' do
    visit tasks_show_path(task)

    click_link '削除'

    expect(page).to have_content 'Deleted'
    expect(page).to have_no_content 'タスク１'
  end
end

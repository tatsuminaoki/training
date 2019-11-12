require 'rails_helper'

RSpec.feature 'Task management', type: :feature do
  scenario 'User creates a new task with name that length is 50' do
    visit new_task_path

    fill_in '名前', with: 'a' * 50
    fill_in '説明', with: '説明'
    select '未着手', from: 'task_status'
    click_button '送信'

    expect(page).to have_text('新しいタスクが作成されました！')
  end

  scenario 'User can not create a new task with name that length is invalid' do
    visit new_task_path

    fill_in '名前', with: 'a' * 51
    fill_in '説明', with: '説明'
    select '未着手', from: 'task_status'
    click_button '送信'

    expect(page).to have_text('名前は50文字以内')
  end

  scenario 'User can not create a new task with empty name' do
    visit new_task_path

    fill_in '名前', with: ''
    fill_in '説明', with: '説明'
    select '未着手', from: 'task_status'
    click_button '送信'

    expect(page).to have_text('名前を入力してください')
  end

  scenario 'User edits a task.' do
    name = 'mytask-spec'
    task = Task.create(name: name, description: 'tmp')
    visit edit_task_path(task)

    # check if in the right place.
    expect(page).to have_selector("input[value=#{name}]")

    name_edited = 'mytask-spec-edited'
    fill_in '名前', with: name_edited
    select '進行中', from: 'task_status'
    click_button '送信'

    # check if updates successfully.
    expect(page).to have_text('タスクが更新されました！')
    expect(page).to have_text(name_edited)
  end

  scenario 'User visit task detail page.' do
    name = 'mytask'
    description = 'mydescription'
    status = 'todo'
    task = Task.create(name: name, description:description, status:status)
    visit task_path(task)

    expect(page).to have_text(name)
    expect(page).to have_text(description)
    expect(page).to have_text('未着手')
  end

  scenario 'User delete a task on detail page.' do
    name = 'task-to-delete'
    task = Task.create(name: name, description: 'tmp')
    visit task_path(task)

    click_link '削除'

    expect(page).to have_text('タスクを削除しました！')
    expect(page).not_to have_text(name)
  end

  scenario 'User lists tasks' do
    name = 'task-to-list'
    task = Task.create(name: name, description: 'tmp')
    visit root_path

    expect(page).to have_text(name)
  end

  scenario 'User list tasks with status todo and a task name' do
    todo_name1 = 'task1-todo'
    todo_name2 = 'task2-todo'
    done_name1 = 'task1-done'
    todo_task1 = Task.create(name: todo_name1, description: 'tmp', status: 'todo')
    todo_task2 = Task.create(name: todo_name2, description: 'tmp', status: 'todo')
    done_task1 = Task.create(name: done_name1, description: 'tmp', status: 'done')

    visit root_path
    fill_in 'name', with: todo_name1
    select '未着手', from: 'status'
    click_button '検索'

    expect(page).not_to have_text('task1-done')
    expect(page).not_to have_text('task2-todo')
    expect(page).to have_text('task1-todo')
  end
end

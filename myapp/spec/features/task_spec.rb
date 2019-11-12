require 'rails_helper'

RSpec.feature 'Task management', type: :feature do
  feature 'creation' do
    context 'with valid name (length le 50)' do
      scenario 'user can creates a new task' do
        visit new_task_path
        fill_in '名前', with: 'a' * 50
        click_button '送信'
        expect(page).to have_text('新しいタスクが作成されました！')
      end
    end

    context 'with invalid name (length over 50)' do
      scenario 'user can not create a new task' do
        visit new_task_path
        fill_in '名前', with: 'a' * 51
        click_button '送信'
        expect(page).to have_text('名前は50文字以内')
      end
    end

    context 'with invalid name (empty string)' do
      scenario 'user can not create a new task' do
        visit new_task_path
        fill_in '名前', with: ''
        click_button '送信'
        expect(page).to have_text('名前を入力してください')
      end
    end
  end

  feature 'modification' do
    before do
      @task = Task.create(name: 'mytask-to-edit', description: 'description', status: 'todo')
    end

    scenario 'user can edit a task' do
      visit edit_task_path(@task)
      name_edited = 'mytask-spec-edited'
      fill_in '名前', with: name_edited
      fill_in '説明', with: 'edited-description'
      select '進行中', from: 'task_status'
      click_button '送信'
      expect(page).to have_text('タスクが更新されました！')
      expect(page).to have_text(name_edited)
    end
  end

  feature 'show' do
    before do
      @task = Task.create(name: 'mytask', description: 'mydescription', status: 'todo')
    end

    scenario 'user can see detail of a task' do
      visit task_path(@task)
      expect(page).to have_text(@task.name)
      expect(page).to have_text(@task.description)
      expect(page).to have_text(@task.readable_status)
    end
  end

  feature 'deletion' do
    before do
      @task = Task.create(name: 'task-to-delete', description: 'description')
    end

    scenario 'user can delete a task' do
      visit task_path(@task)
      click_link '削除'
      expect(page).to have_text('タスクを削除しました！')
      expect(page).not_to have_text(@task.name)
    end
  end

  feature 'list' do
    before do
      @task = Task.create(name: 'task-to-list', description: 'description')
      @task2 = Task.create(name: 'task2-to-list', description: 'description')
    end

    scenario 'user can lists tasks' do
      visit root_path
      expect(page).to have_text(@task.name)
      expect(page).to have_text(@task2.name)
    end
  end

  feature 'search' do
    before do
      @todo_task1 = Task.create(name: 'task1-todo', description: 'tmp', status: 'todo')
      @todo_task2 = Task.create(name: 'task2-todo', description: 'tmp', status: 'todo')
      @done_task1 = Task.create(name: 'task1-done', description: 'tmp', status: 'done')
    end

    context 'with status' do
      scenario 'user can search tasks' do
        visit root_path
        fill_in 'name', with: 'todo'
        click_button '検索'
        expect(page).not_to have_text(@done_task1.name)
        expect(page).to have_text(@todo_task1.name)
        expect(page).to have_text(@todo_task2.name)
      end
    end

    context 'with name' do
      scenario 'user can search tasks' do
        visit root_path
        select '完了', from: 'status'
        click_button '検索'
        expect(page).to have_text(@done_task1.name)
        expect(page).not_to have_text(@todo_task1.name)
        expect(page).not_to have_text(@todo_task2.name)
      end
    end

    context 'with name and status' do
      scenario 'user can search tasks' do
        visit root_path
        fill_in 'name', with: '1-todo'
        select '未着手', from: 'status'
        click_button '検索'
        expect(page).not_to have_text(@done_task1.name)
        expect(page).to have_text(@todo_task1.name)
        expect(page).not_to have_text(@todo_task2.name)
      end
    end
  end
end

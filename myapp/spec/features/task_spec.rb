# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'Task', type: :feature do
  feature 'creation' do
    context 'with valid name (length le 50)' do
      scenario 'user can create a new task' do
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

  feature 'listing' do
    before do
      @old_task = Task.create(name: 'old-task', description: 'description')
      @new_task = Task.create(name: 'new-task', description: 'description')
      @old_task.update(created_at: Time.current.advance(days: -1))
    end

    scenario 'user can lists tasks order by created_at desc' do
      visit root_path
      expect(page.body.index(@old_task.name)).to be > page.body.index(@new_task.name)
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

      scenario 'search params will remains on form' do
        visit root_path
        fill_in 'name', with: 'no-task-found-name'
        select '進行中', from: 'status'
        click_button '検索'
        expect(page).to have_selector('input[value=no-task-found-name]')
        expect(page).to have_selector('option[selected=selected][value=1]')
      end
    end
  end

  feature 'pagination' do
    before do
      5.times do
        Task.create(name: 'todo-task', status: 'todo')
        Task.create(name: 'good-done-task', status: 'done')
        Task.create(name: 'well-done-task', status: 'done')
      end
      visit root_path
      fill_in 'name', with: 'well-done'
      select '完了', from: 'status'
      click_button '検索'
    end

    feature 'search' do
      context 'when first page' do
        scenario 'there is only 2 well done tasks' do
          expect(page).to have_content('well-done-task', count: 2)
          expect(page).not_to have_content('todo-task')
          expect(page).not_to have_content('good-done-task')
        end
      end

      context 'when middle page' do
        scenario 'there is only 2 well done tasks' do
          click_link '次'
          expect(page).to have_content('well-done-task', count: 2)
          expect(page).not_to have_content('todo-task')
          expect(page).not_to have_content('good-done-task')
        end
      end

      context 'when last page' do
        scenario 'there is only 1 well done task' do
          click_link '最後'
          expect(page).to have_content('well-done-task', count: 1)
          expect(page).not_to have_content('todo-task')
          expect(page).not_to have_content('good-done-task')
        end
      end
    end
  end
end

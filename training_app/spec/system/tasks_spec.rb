# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Tasks', type: :system do
  feature 'タスク一覧' do
    given!(:task) { Task.create!(title: 'ABC') }

    scenario '一覧に表示される' do
      visit tasks_path
      expect(page).to have_content(task.title)
    end

    scenario 'Destroy をクリックすると削除される' do
      visit tasks_path

      click_link 'Destroy'
      page.accept_confirm 'Are you sure?'

      expect(page).to have_content 'Task was successfully destroyed.'
      expect(Task.count).to eq(0)
    end
  end

  feature 'タスク詳細' do
    given!(:task) { Task.create!(title: 'ABC') }

    scenario '一覧に表示される' do
      visit task_path(task)

      expect(page).to have_content(task.title)
      expect(page).to have_content(task.body)
    end
  end

  feature 'タスク新規登録' do
    scenario 'タイトルと本文を入力すると登録される' do
      visit new_task_path

      fill_in 'Title', with: 'Hoge'
      fill_in 'Body', with: 'Foo'

      click_on 'Create Task'

      task = Task.last

      expect(task.title).to eq('Hoge')
      expect(task.body).to eq('Foo')
    end

    scenario '登録すると #show に遷移する' do
      visit new_task_path

      fill_in 'Title', with: 'Hoge'
      click_on 'Create Task'

      task = Task.last
      expect(page).to have_current_path(task_path(task))
      expect(page).to have_content 'Task was successfully created.'
    end
  end

  feature 'タスク更新' do
    given!(:task) { Task.create(title: 'ABC', body: 'DEF') }

    scenario '登録済のタスクが入力されている' do
      visit edit_task_path(task)

      expect(page).to have_field 'Title', with: 'ABC'
      expect(page).to have_field 'Body', with: 'DEF'
    end

    scenario '登録済のタスクが入力されている' do
      visit edit_task_path(task)

      fill_in 'Title', with: 'DEF'
      fill_in 'Body', with: 'ABC'

      click_on 'Update Task'

      update_task = Task.find(task.id)

      expect(update_task.title).to eq('DEF')
      expect(update_task.body).to eq('ABC')
      expect(page).to have_content 'Task was successfully updated.'
    end
  end
end

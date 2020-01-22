# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Tasks', type: :system do
  feature 'タスク一覧' do
    given!(:task1) { Task.create!(title: 'ABC') }
    given!(:task2) { Task.create!(title: 'DEF') }

    scenario '一覧に表示される' do
      visit tasks_path

      expect(page).to have_content(task1.title)
      expect(page).to have_content(task2.title)
    end

    scenario '一覧には作成順の降順で表示される' do
      visit tasks_path

      titles = all('.task-title')

      expect(titles[0].native.text).to have_content(task2.title)
      expect(titles[1].native.text).to have_content(task1.title)
    end

    scenario 'Destroy をクリックすると削除される' do
      visit tasks_path

      click_link I18n.t('destroy')
      page.accept_confirm I18n.t('tasks.index.sure')

      expect(page).to have_content I18n.t('tasks.index.destroy')
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

      fill_in Task.human_attribute_name(:title), with: 'Hoge'
      fill_in Task.human_attribute_name(:body), with: 'Foo'

      click_on I18n.t('helpers.submit.create')

      task = Task.last

      expect(task.title).to eq('Hoge')
      expect(task.body).to eq('Foo')
    end

    scenario '登録すると #show に遷移する' do
      visit new_task_path

      fill_in Task.human_attribute_name(:title), with: 'Hoge'
      click_on I18n.t('helpers.submit.create')

      task = Task.last
      expect(page).to have_current_path(task_path(task))
      expect(page).to have_content I18n.t('tasks.new.create')
    end
  end

  feature 'タスク更新' do
    given!(:task) { Task.create(title: 'ABC', body: 'DEF') }

    scenario '登録済のタスクが入力されている' do
      visit edit_task_path(task)

      expect(page).to have_field Task.human_attribute_name(:title), with: 'ABC'
      expect(page).to have_field Task.human_attribute_name(:body), with: 'DEF'
    end

    scenario '登録済のタスクが入力されている' do
      visit edit_task_path(task)

      fill_in Task.human_attribute_name(:title), with: 'DEF'
      fill_in Task.human_attribute_name(:body), with: 'ABC'

      click_on I18n.t('helpers.submit.update')

      update_task = Task.find(task.id)

      expect(update_task.title).to eq('DEF')
      expect(update_task.body).to eq('ABC')
      expect(page).to have_content I18n.t('tasks.edit.update')
    end
  end
end

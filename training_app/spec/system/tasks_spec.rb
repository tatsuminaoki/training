# frozen_string_literal: true

require 'rails_helper'

def blank_error_message(attr)
  I18n.t(
    'errors.format',
    attribute: Task.human_attribute_name(attr),
    message: I18n.t('errors.messages.blank'),
  )
end

RSpec.describe 'Tasks', type: :system do
  feature 'タスク一覧' do
    given!(:user) { create(:user) }
    background do
      sign_in_with(user)
    end

    given!(:task1) { create(:task, user: user) }
    given!(:task2) { create(:task, user: user) }

    scenario '一覧に表示される' do
      visit tasks_path

      expect(page).to have_content(task1.title)
      expect(page).to have_content(task2.title)
    end

    scenario '自分のタスク以外は表示されない' do
      # 自分以外のタスク作成
      other = create(:user)
      other_task = create(:task, user: other)

      visit tasks_path

      expect(page).to have_content(task1.title)
      expect(page).to have_content(task2.title)
      expect(page).to have_no_content(other_task.title)
    end

    scenario '一覧には作成順の降順で表示される' do
      visit tasks_path

      titles = all('.task-title')

      expect(titles[0].native.text).to have_content(task2.title)
      expect(titles[1].native.text).to have_content(task1.title)
    end

    scenario '削除をクリックすると削除される' do
      visit tasks_path

      find(".task#{task1.id}-remove-link").click
      page.accept_confirm I18n.t('tasks.index.sure')

      expect(page).to have_content I18n.t('tasks.index.destroy')
      expect(Task.count).to eq(1)
    end

    scenario '検索を行うことができる' do
      visit tasks_path

      fill_in 'q[title_cont]', with: task1.title
      click_on I18n.t('helpers.submit.search')

      expect(page).to have_content(task1.title)
      expect(page).to have_no_content(task2.title)
    end
  end

  feature 'タスク詳細' do
    given!(:user) { create(:user) }
    background do
      sign_in_with(user)
    end

    given!(:task) { create(:task, user: user) }

    scenario '一覧に表示される' do
      visit task_path(task)

      expect(page).to have_content(task.title)
      expect(page).to have_content(task.body)
    end
  end

  feature 'タスク新規登録' do
    given!(:user) { create(:user) }
    background do
      sign_in_with(user)
    end

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
      fill_in Task.human_attribute_name(:body), with: 'Foo'

      click_on I18n.t('helpers.submit.create')

      task = Task.last
      expect(page).to have_current_path(task_path(task))
      expect(page).to have_content I18n.t('tasks.new.create')
    end

    scenario 'タイトルと本文が空白だとエラーが表示される' do
      visit new_task_path

      click_on I18n.t('helpers.submit.create')

      expect(page).to have_content blank_error_message(:title)
      expect(page).to have_content blank_error_message(:body)
    end
  end

  feature 'タスク更新' do
    given!(:user) { create(:user) }
    background do
      sign_in_with(user)
    end

    given!(:task) { create(:task, title: 'ABC', body: 'DEF', user: user) }

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

    scenario 'タイトルと本文が空白だとエラーが表示される' do
      visit edit_task_path(task)

      fill_in Task.human_attribute_name(:title), with: ''
      fill_in Task.human_attribute_name(:body), with: ''

      click_on I18n.t('helpers.submit.update')

      expect(page).to have_content blank_error_message(:title)
      expect(page).to have_content blank_error_message(:body)
    end
  end
end

# frozen_string_literal: true

require 'rails_helper'
require 'selenium-webdriver'

RSpec.feature 'Tasks', type: :feature do
  let (:login_user) { create(:user) }
  before do
    visit root_path
    fill_in I18n.t('helpers.label.session.email'), with: login_user.email
    fill_in I18n.t('helpers.label.session.password'), with: login_user.password
    click_button I18n.t('sessions.new.submit')
  end

  scenario '新しいタスクを作成' do
    expect do
      click_link I18n.t('tasks.index.new_task')
      fill_in I18n.t('tasks.index.title'), with: 'First content'
      fill_in I18n.t('tasks.index.content'), with: 'Rspec test'
      first("li.tagit-new > input[type='text']").set('label1, label2')
      click_button I18n.t('helpers.submit.create')
      expect(page).to have_content I18n.t('flash.task.create')
      expect(page).to have_content('First content')
      expect(page).to have_content('Rspec test')
      expect(find('.tagit')).to have_content('label1')
    end.to change { Task.count }.by(1)
  end

  scenario 'タスクの修正' do
    click_link I18n.t('tasks.index.new_task')
    fill_in I18n.t('tasks.index.title'), with: 'First content'
    fill_in I18n.t('tasks.index.content'), with: 'Rspec test'
    first("li.tagit-new > input[type='text']").set('label1, label2')
    click_button I18n.t('helpers.submit.create')
    click_link I18n.t('tasks.index.back')
    expect do
      click_link I18n.t('tasks.index.edit')
      fill_in I18n.t('tasks.index.title'), with: 'After modify'
      fill_in I18n.t('tasks.index.content'), with: 'Sleepy morning'
      first("li.tagit-new > input[type='text']").set('new1, new2')
      click_button I18n.t('helpers.submit.update')
      expect(page).to have_content I18n.t('flash.task.update')
      expect(page).to have_content('After modify')
      expect(page).to have_content('Sleepy morning')
      expect(find('.tagit')).to have_content('new1')
    end.to change { Task.count }.by(0)
  end

  scenario 'タスクの削除', js: true do
    click_link I18n.t('tasks.index.new_task')
    fill_in I18n.t('tasks.index.title'), with: 'Delete content'
    fill_in I18n.t('tasks.index.content'), with: 'delete this'
    click_button I18n.t('helpers.submit.create')
    click_link I18n.t('tasks.index.back')
    expect do
      click_link I18n.t('tasks.index.delete')
      page.driver.browser.switch_to.alert.accept
      expect(page).to have_content I18n.t('flash.task.delete')
    end.to change { Task.count }.by(-1)
  end

  scenario 'タスクの作成日順並べ替えテスト' do
    expect do
      create(:task, title: 'task1', created_at: '2018-9-29', user_id: login_user.id)
      create(:task, title: 'task2', created_at: '2018-9-30', user_id: login_user.id)
      titles = page.all('td.title')
      expect(titles[0]).to have_content 'task2'
      expect(titles[1]).to have_content 'task1'
    end
  end

  scenario '一覧画面で終了期限で整列されていること' do
    expect do
      create(:task, title: 'task1', end_time: '2018-9-29 12:10:10', user_id: login_user.id)
      create(:task, title: 'task2', end_time: '2018-9-30 12:10:10', user_id: login_user.id)
      visit root_path
      asc_titles = page.all('td.title')
      click_link '終了時間'
      expect(asc_titles[0]).to have_content 'task1'
      expect(asc_titles[1]).to have_content 'task2'
      click_link '終了時間'
      desc_titles = page.all('td.title')
      expect(desc_titles[0]).to have_content 'task2'
      expect(desc_titles[1]).to have_content 'task1'
    end
  end

  scenario '一覧画面でタイトル名と状態で検索' do
    expect do
      create(:task, title: 'task1', status: 'do', user_id: login_user.id)
      create(:task, title: 'task2', status: 'done', user_id: login_user.id)
      visit root_path
      fill_in I18n.t('tasks.index.search_title'), with: 'task1'
      select I18n.t('tasks.status.do'), from: I18n.t('tasks.index.search_status')
      click_button I18n.t('tasks.index.search_submit')
      expect(page).to have_content('task1')
      expect(page).not_to have_content('task2')
    end
  end

  scenario 'タスク五つのページネーション確認' do
    expect do
      create_list(:task, 6, user_id: login_user.id)
      visit root_path
      titles = page.all('td.title')
      expect(titles[4]).to have_content 'task5'
      expect(titles[5]).to be_nil
      click_link I18n.t('views.pagination.next')
      titles = page.all('td.title')
      expect(titles[0]).to have_content 'task6'
    end
  end
end

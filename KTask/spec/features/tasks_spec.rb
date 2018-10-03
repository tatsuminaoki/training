# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'Tasks', type: :feature do
  scenario '新しいタスクを作成' do
    expect do
      visit root_path
      click_link '新規タスク登録'
      fill_in 'スケジュール', with: 'First content'
      fill_in '内容', with: 'Rspec test'
      click_button '登録する'
      expect(page).to have_content('タスクを作成しました')
      expect(page).to have_content('First content')
      expect(page).to have_content('Rspec test')
    end.to change { Task.count }.by(1)
  end

  scenario 'タスクの修正' do
    visit root_path
    click_link '新規タスク登録'
    fill_in 'スケジュール', with: 'Before modify'
    fill_in '内容', with: 'Rspec test'
    click_button '登録する'
    click_link '戻る'
    expect do
      click_link '修正'
      fill_in 'スケジュール', with: 'After modify'
      fill_in '内容', with: 'Sleepy morning'
      click_button '更新する'
      expect(page).to have_content('タスクを修正しました')
      expect(page).to have_content('After modify')
      expect(page).to have_content('Sleepy morning')
    end.to change { Task.count }.by(0)
  end

  scenario 'タスクの削除' do
    visit root_path
    click_link '新規タスク登録'
    fill_in 'スケジュール', with: 'Delete Test'
    fill_in '内容', with: 'Delete this'
    click_button '登録する'
    click_link '戻る'
    expect do
      click_link '削除'
      expect(page).to have_content('タスクを削除しました')
    end.to change { Task.count }.by(-1)
  end

  scenario 'タスクの作成日順並べ替えテスト' do
    visit root_path
    click_link '新規タスク登録'
    fill_in 'スケジュール', with: 'task1'
    fill_in '内容', with: 'task1'
    click_button '登録する'
    click_link '戻る'
    click_link '新規タスク登録'
    fill_in 'スケジュール', with: 'task2'
    fill_in '内容', with: 'task2'
    click_button '登録する'
    click_link '戻る'
    titles = page.all('td.title')
    expect(titles[0]).to have_content('task2')
    expect(titles[1]).to have_content('task1')
  end

  scenario '一覧画面で終了期限で整列されていること' do
    FactoryBot.create(:task, id: 0, title: 'task1', end_time: '2018-9-29 12:10:10')
    FactoryBot.create(:task, id: 1, title: 'task2', end_time: '2018-9-30 12:10:10')
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
  scenario '一覧画面でタイトル名と状態で検索' do
    create(:task, title: 'task1', status: 'do')
    create(:task, title: 'task2', status: 'done')
    visit root_path
    fill_in I18n.t('tasks.index.search_title'), with: 'task1'
    select I18n.t('tasks.status.do'), from: I18n.t('tasks.index.search_status')
    click_button I18n.t('tasks.index.search_submit')
    expect(page).to have_content('task1')
    expect(page).not_to have_content('task2')
  end
end

# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'Tasks', type: :feature do
  let(:user) { FactoryBot.create :user }
  scenario '新しいタスクを作成' do
    expect do
      task = create(:task, title: 'task1', user_id: user.id)
      visit root_path
      expect(page).to have_content('task1')
    end.to change { Task.count }.by(1)
  end

  scenario 'タスクの修正' do
    task = create(:task, title: 'task1', user_id: user.id)
    visit root_path
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
    task = create(:task, title: 'task1', user_id: user.id)
    visit root_path
    expect do
      click_link '削除'
      expect(page).to have_content('タスクを削除しました')
    end.to change { Task.count }.by(-1)
  end

  scenario 'タスクの作成日順並べ替えテスト' do
    create(:task, title: 'task1', created_at: '2018-9-29', user_id: user.id)
    create(:task, title: 'task2', created_at: '2018-9-30', user_id: user.id)
    visit root_path
    titles = page.all('td.title')
    expect(titles[0]).to have_content 'task2'
    expect(titles[1]).to have_content 'task1'
  end

  scenario '一覧画面で終了期限で整列されていること' do
    create(:task, title: 'task1', end_time: '2018-9-29 12:10:10', user_id: user.id)
    create(:task, title: 'task2', end_time: '2018-9-30 12:10:10', user_id: user.id)
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
    create(:task, title: 'task1', status: 'do', user_id: user.id)
    create(:task, title: 'task2', status: 'done', user_id: user.id)
    visit root_path
    fill_in I18n.t('tasks.index.search_title'), with: 'task1'
    select I18n.t('tasks.status.do'), from: I18n.t('tasks.index.search_status')
    click_button I18n.t('tasks.index.search_submit')
    expect(page).to have_content('task1')
    expect(page).not_to have_content('task2')
  end
  scenario 'タスク五つのページネーション確認' do
    create_list(:task, 6 , user_id: user.id)
    visit root_path
    titles = page.all('td.title')
    expect(titles[4]).to have_content 'task5'
    expect(titles[5]).to be_nil
    click_link I18n.t('views.pagination.next')
    titles = page.all('td.title')
    expect(titles[0]).to have_content 'task6'
  end
end

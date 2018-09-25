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
    Task.create(id: 1, title: 'Task 1', created_at: Time.current + 1.day)
    Task.create(id: 2, title: 'Task 2', created_at: Time.current + 2.days)

    expect(Task.order('created_at DESC').map(&:id)).to eq [2, 1]
  end
end

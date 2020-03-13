# frozen_string_literal: true

require 'rails_helper'

describe 'タスク管理機能', type: :system do
  let!(:task) { FactoryBot.create(:task) }

  describe '一覧表示' do
    before do
      visit tasks_path
    end

    it '作成したタスクが表示される' do
      expect(page).to have_content 'テスト'
    end
  end

  describe '詳細表示' do
    before do
      visit task_path(task)
    end

    it '作成したタスクの詳細が表示される' do
      expect(page).to have_content 'テストです'
    end
  end

  describe '新規作成' do
    before do
      visit new_task_path
      fill_in 'task_title', with: '新規タスク'
      click_button '登録する'
    end

    it 'タスクが新規作成される' do
      expect(page).to have_content '新規タスク'
      expect(Task.count).to eq 2
    end
  end

  describe '編集' do
    before do
      visit edit_task_path(task)
      fill_in 'task_title', with: '編集した'
      click_button '更新する'
    end

    it 'タスクが編集される' do
      expect(page).to have_content '編集した'
    end
  end

  describe '削除' do
    before do
      visit tasks_path
      click_link '削除'
      page.driver.browser.switch_to.alert.accept
    end

    it 'タスクが削除される' do
      expect(page).to have_no_content task[:priority]
      expect(Task.count).to eq 0
    end
  end
end

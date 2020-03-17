# frozen_string_literal: true

require 'rails_helper'

describe 'タスク管理機能', type: :system do
  let(:test_task) { FactoryBot.create(:task) }

  describe '一覧表示' do
    it '作成したタスクが表示される' do
      test_task
      visit tasks_path
      expect(page).to have_content 'テスト'
    end

    it '作成日時の降順で表示される' do
      FactoryBot.create(:task, title: '1st', created_at: Time.zone.now)
      FactoryBot.create(:task, title: '2nd', created_at: 1.day.ago)
      FactoryBot.create(:task, title: '3rd', created_at: 2.days.ago)
      visit tasks_path
      tds = all('table tr')[1].all('td')
      expect(tds[0]).to have_content '1st'
      tds = all('table tr')[2].all('td')
      expect(tds[0]).to have_content '2nd'
      tds = all('table tr')[3].all('td')
      expect(tds[0]).to have_content '3rd'
    end
  end

  describe '詳細表示' do
    before do
      visit task_path(test_task)
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
      expect(Task.count).to eq 1
    end
  end

  describe '編集' do
    before do
      visit edit_task_path(test_task)
      fill_in 'task_title', with: '編集した'
      click_button '更新する'
    end

    it 'タスクが編集される' do
      expect(page).to have_content '編集した'
    end
  end

  describe '削除' do
    before do
      test_task
      visit tasks_path
      click_link '削除'
      page.driver.browser.switch_to.alert.accept
    end

    it 'タスクが削除される' do
      expect(page).to have_no_content test_task[:priority]
      expect(Task.count).to eq 0
    end
  end
end

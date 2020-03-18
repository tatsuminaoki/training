# frozen_string_literal: true

require 'rails_helper'

describe 'タスク管理機能', type: :system do
  let(:test_task) { FactoryBot.create(:task) }

  describe '一覧表示' do
    before do
      FactoryBot.create(:task, title: '1st', deadline: Time.zone.now, created_at: Time.zone.now)
      FactoryBot.create(:task, title: '2nd', deadline: 1.day.ago, created_at: 1.day.ago)
      FactoryBot.create(:task, title: '3rd', deadline: 2.days.ago, created_at: 2.days.ago)
      visit tasks_path
    end

    it '作成日時の降順で表示される' do
      trs = all('table tr')
      tds = trs[1].all('td')
      expect(tds[0]).to have_content '1st'
      tds = trs[2].all('td')
      expect(tds[0]).to have_content '2nd'
      tds = trs[3].all('td')
      expect(tds[0]).to have_content '3rd'
    end

    it '期限のリンクを1回踏むと、降順で表示される' do
      click_link '期限'
      # DOMが生成されるまで待つ
      sleep 0.1
      trs = all('table tr')
      tds = trs[1].all('td')
      expect(tds[0]).to have_content '1st'
      tds = trs[2].all('td')
      expect(tds[0]).to have_content '2nd'
      tds = trs[3].all('td')
      expect(tds[0]).to have_content '3rd'
    end

    it '期限のリンクを2回踏むと、昇順で表示される' do
      click_link '期限'
      click_link '期限'
      sleep 0.1
      trs = all('table tr')
      tds = trs[1].all('td')
      expect(tds[0]).to have_content '3rd'
      tds = trs[2].all('td')
      expect(tds[0]).to have_content '2nd'
      tds = trs[3].all('td')
      expect(tds[0]).to have_content '1st'
    end

    it '期限のリンクを3回踏むと、作成日時の降順で表示される' do
      click_link '期限'
      click_link '期限'
      click_link '期限'
      sleep 0.1
      trs = all('table tr')
      tds = trs[1].all('td')
      expect(tds[0]).to have_content '1st'
      tds = trs[2].all('td')
      expect(tds[0]).to have_content '2nd'
      tds = trs[3].all('td')
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

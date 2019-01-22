# frozen_string_literal: true

require 'rails_helper'

feature 'タスク管理機能', type: :feature do
  feature '一覧機能' do
    let!(:first_task) { FactoryBot.create(:task) }

    scenario '初期レコードが確認できる' do
      visit root_path
      expect(page).to have_no_selector '.alert-success'
      expect(page).to have_content '掃除'
    end
  end

  feature '登録機能' do
    before do
      visit root_path
      click_on('タスク登録')
      fill_in 'タスク名', with: task_name
      fill_in '説明', with: task_description
      click_on('送信')
    end

    context '登録画面で名前と説明を入力したとき' do
      let(:task_name) { '最初のタスク' }
      let(:task_description) { '最初のタスクの説明' }

      scenario '正常に登録される' do
        expect(page).to have_selector '.alert-success', text: '最初のタスク'
        expect(Task.count).to eq 1
      end
    end
  end

  feature '編集機能' do
    let!(:first_task) { FactoryBot.create(:task) }

    before do
      visit root_path
      click_on('編集')
      fill_in '説明', with: task_description
      click_on('送信')
    end

    context '編集画面で名前と説明を入力したとき' do
      let(:task_description) { 'トイレ,風呂,キッチン' }

      scenario '正常に更新される' do
        expect(page).to have_selector '.alert-success', text: '更新しました。'
        expect(page).to have_content 'トイレ,風呂,キッチン'
      end
    end
  end

  feature '削除機能' do
    let!(:first_task) { FactoryBot.create(:task) }

    before do
      visit root_path
      click_on('削除')
    end

    context '確認ダイアログのOKを押したとき' do
      scenario '正常に削除される' do
        page.driver.browser.switch_to.alert.accept
        expect(page).to have_selector '.alert-success', text: 'タスク「掃除」を削除しました。'
        expect(Task.count).to eq 0
      end
    end
  end
end

# frozen_string_literal: true

require 'rails_helper'

feature 'タスク管理機能', type: :feature do
  shared_examples_for 'validationエラーが表示される' do
    context '空欄のまま送信したとき' do
      let(:task_name) { '' }
      let(:task_description) { '' }

      scenario '入力を促すエラーメッセージが表示される' do
        expect(page).to have_selector '#error_explanation', text: 'タスク名を入力してください'
        expect(page).to have_selector '#error_explanation', text: '説明を入力してください'
      end
    end

    context '制限を超えた文字数を入力したとき' do
      let(:task_name) { 'a' * 31 }
      let(:task_description) { 'a' * 801 }

      scenario '文字数に関するエラーメッセージが表示される' do
        expect(page).to have_selector '#error_explanation', text: '30文字以内'
        expect(page).to have_selector '#error_explanation', text: '800文字以内'
      end
    end
  end

  feature '一覧機能' do
    let!(:first_task) { FactoryBot.create(:task) }

    scenario '初期レコードが確認できる' do
      visit root_path
      expect(page).to have_no_selector '.alert-success'
      expect(page).to have_content '掃除'
    end
  end

  feature 'タスクの並び順' do
    let!(:tasks) {
      [
        FactoryBot.create(:task, name: 'タスク1', description: 'タスク1の説明', created_at: Time.zone.now),
        FactoryBot.create(:task, name: 'タスク2', description: 'タスク2の説明', created_at: 1.day.ago),
        FactoryBot.create(:task, name: 'タスク3', description: 'タスク3の説明', created_at: 2.days.ago),
      ]
    }

    scenario 'タスクが登録日時の降順で並ぶ' do
      visit root_path

      page.all('.task-list tbody tr').each_with_index do |element, i|
        next if i <= 0
        expect(element.text).to have_content tasks[i - 1].name
      end
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

    context '名前と説明を入力したとき' do
      let(:task_name) { '最初のタスク' }
      let(:task_description) { '最初のタスクの説明' }

      scenario '正常に登録される' do
        expect(page).to have_selector '.alert-success', text: '最初のタスク'
        expect(Task.count).to eq 1
      end
    end

    it_behaves_like 'validationエラーが表示される'
  end

  feature '編集機能' do
    let!(:first_task) { FactoryBot.create(:task) }

    before do
      visit root_path
      click_on('編集')
      fill_in 'タスク名', with: task_name
      fill_in '説明', with: task_description
      click_on('送信')
    end

    context '名前と説明を入力したとき' do
      let(:task_name) { '掃除' }
      let(:task_description) { 'トイレ,風呂,キッチン' }

      scenario '正常に更新される' do
        expect(page).to have_selector '.alert-success', text: '更新しました。'
        expect(page).to have_content 'トイレ,風呂,キッチン'
      end
    end

    it_behaves_like 'validationエラーが表示される'
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

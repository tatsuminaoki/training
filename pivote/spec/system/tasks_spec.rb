# frozen_string_literal: true

require 'rails_helper'

describe 'タスク管理機能', type: :system do
  let(:single_task) { FactoryBot.create(:task) }
  let(:tasks_1) {
    FactoryBot.create(:task, title: task1_title, priority: :high, status: :waiting, deadline: Time.zone.now, created_at: Time.zone.now)
    FactoryBot.create(:task, title: task2_title, priority: :middle, status: :doing, deadline: 1.day.ago, created_at: 1.day.ago)
    FactoryBot.create(:task, title: task3_title, priority: :low, status: :done, deadline: 2.days.ago, created_at: 2.days.ago)
  }
  let(:task1_title) { '1st' }
  let(:task2_title) { '2nd' }
  let(:task3_title) { '3rd' }
  let(:task1_i) { page.body.index(task1_title) }
  let(:task2_i) { page.body.index(task2_title) }
  let(:task3_i) { page.body.index(task3_title) }
  let(:tasks_2) {
    FactoryBot.create(:task, title: task4_title, priority: :high, status: :done, deadline: 4.days.ago, created_at: 4.days.ago)
    FactoryBot.create(:task, title: task5_title, priority: :middle, status: :doing, deadline: 5.days.ago, created_at: 5.days.ago)
    FactoryBot.create(:task, title: task6_title, priority: :low, status: :waiting, deadline: 6.days.ago, created_at: 6.days.ago)
  }
  let(:task4_title) { '4th' }
  let(:task5_title) { '5th' }
  let(:task6_title) { '6th' }
  let(:task4_i) { page.body.index(task4_title) }
  let(:task5_i) { page.body.index(task5_title) }
  let(:task6_i) { page.body.index(task6_title) }

  describe 'ソート機能' do
    before do
      tasks_1
      visit tasks_path
    end

    context '何も指定していないとき' do
      it '作成日時の降順で表示される' do
        expect(task1_i).to be < task2_i
        expect(task2_i).to be < task3_i
      end
    end

    context '優先度のリンクを1回踏んだとき' do
      it '優先度の降順で表示される' do
        click_link '優先度'
        sleep 0.1
        expect(task1_i).to be < task2_i
        expect(task2_i).to be < task3_i
      end
    end

    context '優先度のリンクを2回踏んだとき' do
      it '優先度の昇順で表示される' do
        click_link '優先度'
        click_link '優先度'
        sleep 0.1
        expect(task3_i).to be < task2_i
        expect(task2_i).to be < task1_i
      end
    end

    context '優先度のリンクを3回踏んだとき' do
      it '作成日時の降順で表示される' do
        click_link '優先度'
        click_link '優先度'
        click_link '優先度'
        sleep 0.1
        expect(task1_i).to be < task2_i
        expect(task2_i).to be < task3_i
      end
    end

    context 'ステータスのリンクを1回踏んだとき' do
      it 'ステータスの降順で表示される' do
        click_link 'ステータス'
        sleep 0.1
        expect(task1_i).to be < task2_i
        expect(task2_i).to be < task3_i
      end
    end

    context 'ステータスのリンクを2回踏んだとき' do
      it 'ステータスの昇順で表示される' do
        click_link 'ステータス'
        click_link 'ステータス'
        sleep 0.1
        expect(task3_i).to be < task2_i
        expect(task2_i).to be < task1_i
      end
    end

    context 'ステータスのリンクを3回踏んだとき' do
      it '作成日時の降順で表示される' do
        click_link 'ステータス'
        click_link 'ステータス'
        click_link 'ステータス'
        sleep 0.1
        expect(task1_i).to be < task2_i
        expect(task2_i).to be < task3_i
      end
    end

    context '期限のリンクを1回踏んだとき' do
      it '期限の降順で表示される' do
        click_link '期限'
        sleep 0.1
        expect(task1_i).to be < task2_i
        expect(task2_i).to be < task3_i
      end
    end

    context '期限のリンクを2回踏んだとき' do
      it '期限の昇順で表示される' do
        click_link '期限'
        click_link '期限'
        sleep 0.1
        expect(task3_i).to be < task2_i
        expect(task2_i).to be < task1_i
      end
    end

    context '期限のリンクを3回踏んだとき' do
      it '作成日時の降順で表示される' do
        click_link '期限'
        click_link '期限'
        click_link '期限'
        sleep 0.1
        expect(task1_i).to be < task2_i
        expect(task2_i).to be < task3_i
      end
    end
  end

  describe '検索機能' do
    before do
      tasks_1
      tasks_2
      visit tasks_path
    end

    context '優先度で検索したとき' do
      it '選択した優先度のタスクが表示される' do
        select '高', from: 'search[priority]'
        click_button '検索'
        expect(page).to have_content task1_title
        expect(page).to have_no_content task2_title
        expect(page).to have_no_content task3_title
      end
    end

    context 'ステータスで検索したとき' do
      it '選択したステータスのタスクが表示される' do
        select '着手', from: 'search[status]'
        click_button '検索'
        expect(page).to have_content task2_title
        expect(page).to have_no_content task1_title
        expect(page).to have_no_content task3_title
      end
    end

    context '名称で検索したとき' do
      it '選択した名称のタスクが表示される' do
        fill_in 'search[title]', with: task3_title
        click_button '検索'
        expect(page).to have_content task3_title
        expect(page).to have_no_content task1_title
        expect(page).to have_no_content task2_title
      end
    end

    context '優先度とステータスで検索したとき' do
      it '選択した優先度とステータスのタスクが表示される' do
        select '低', from: 'search[priority]'
        select '未着手', from: 'search[status]'
        click_button '検索'
        expect(page).to have_content task6_title
        expect(page).to have_no_content task3_title
      end
    end

    context 'ステータスと名称で検索したとき' do
      it '選択したステータスと名称のタスクが表示される' do
        select '完了', from: 'search[status]'
        fill_in 'search[title]', with: task4_title
        click_button '検索'
        expect(page).to have_content task4_title
        expect(page).to have_no_content task3_title
      end
    end

    context '優先度と名称で検索したとき' do
      it '選択した優先度と名称のタスクが表示される' do
        select '中', from: 'search[priority]'
        fill_in 'search[title]', with: task5_title
        click_button '検索'
        expect(page).to have_content task5_title
        expect(page).to have_no_content task2_title
      end
    end
  end

  describe 'ページネーション' do
    before do
      (1..100).each { |i|
        FactoryBot.create(:task, title: "ページネーションタスク#{i}", created_at: i.days.ago)
      }
      visit tasks_path
    end

    context '「2」のリンクを踏んだとき' do
      it '21番目のタスクが表示される' do
        click_link '2'
        expect(page).to have_content 'ページネーションタスク21'
        expect(page).to have_no_content 'ページネーションタスク20'
      end
    end

    context '「最後」のリンクを踏んだとき' do
      it '100番目のタスクが表示される' do
        click_link '最後 »'
        expect(page).to have_content 'ページネーションタスク100'
        expect(page).to have_no_content 'ページネーションタスク80'
      end
    end
  end

  describe '詳細表示' do
    before do
      visit task_path(single_task)
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
      visit edit_task_path(single_task)
      fill_in 'task_title', with: '編集した'
      click_button '更新する'
    end

    it 'タスクが編集される' do
      expect(page).to have_content '編集した'
    end
  end

  describe '削除' do
    before do
      single_task
      visit tasks_path
      click_link '削除'
      page.driver.browser.switch_to.alert.accept
    end

    it 'タスクが削除される' do
      expect(page).to have_no_content single_task[:priority]
      expect(Task.count).to eq 0
    end
  end
end

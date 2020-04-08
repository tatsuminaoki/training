# frozen_string_literal: true

require 'rails_helper'

describe 'タスク管理機能', type: :system do
  let(:user_a) { FactoryBot.create(:user, name: 'Aさん', email: 'a@example.com') }
  let(:single_task) { FactoryBot.create(:task, user: user_a) }
  let(:label1) { FactoryBot.create(:label, name: 'label_1', user: user_a) }
  let(:label2) { FactoryBot.create(:label, name: 'label_2', user: user_a) }
  let(:label3) { FactoryBot.create(:label, name: 'label_3', user: user_a) }
  let(:labels) {
    label1
    label2
    label3
  }
  let(:single_task_label_1) { FactoryBot.create(:task_label, task: single_task, label: label1) }
  let(:single_task_label_2) { FactoryBot.create(:task_label, task: single_task, label: label2) }

  let(:task1) { FactoryBot.create(:task, title: task1_title, priority: :high, status: :waiting, deadline: Time.zone.now, created_at: Time.zone.now, user: user_a) }
  let(:task2) { FactoryBot.create(:task, title: task2_title, priority: :middle, status: :doing, deadline: 1.day.ago, created_at: 1.day.ago, user: user_a) }
  let(:task3) { FactoryBot.create(:task, title: task3_title, priority: :low, status: :done, deadline: 2.days.ago, created_at: 2.days.ago, user: user_a) }
  let(:task_label1) { FactoryBot.create(:task_label, task: task1, label: label1) }
  let(:task_label2) { FactoryBot.create(:task_label, task: task2, label: label2) }
  let(:task_label3) { FactoryBot.create(:task_label, task: task3, label: label3) }
  let(:task1_title) { '1st' }
  let(:task2_title) { '2nd' }
  let(:task3_title) { '3rd' }
  let(:tasks_1) {
    task_label1
    task_label2
    task_label3
  }
  let(:task1_i) { page.body.index(task1_title) }
  let(:task2_i) { page.body.index(task2_title) }
  let(:task3_i) { page.body.index(task3_title) }

  let(:task4) { FactoryBot.create(:task, title: task4_title, priority: :high, status: :done, deadline: 4.days.ago, created_at: 4.days.ago, user: user_a) }
  let(:task5) { FactoryBot.create(:task, title: task5_title, priority: :middle, status: :doing, deadline: 5.days.ago, created_at: 5.days.ago, user: user_a) }
  let(:task6) { FactoryBot.create(:task, title: task6_title, priority: :low, status: :waiting, deadline: 6.days.ago, created_at: 6.days.ago, user: user_a) }
  let(:task_label4) { FactoryBot.create(:task_label, task: task4, label: label2) }
  let(:task_label5) { FactoryBot.create(:task_label, task: task5, label: label3) }
  let(:task_label6) { FactoryBot.create(:task_label, task: task6, label: label1) }
  let(:task4_title) { '4th' }
  let(:task5_title) { '5th' }
  let(:task6_title) { '6th' }
  let(:tasks_2) {
    task_label4
    task_label5
    task_label6
  }
  let(:task4_i) { page.body.index(task4_title) }
  let(:task5_i) { page.body.index(task5_title) }
  let(:task6_i) { page.body.index(task6_title) }

  describe 'ログイン前提の処理' do
    before do
      visit login_path
      fill_in 'session_email', with: user_a.email
      fill_in 'session_password', with: user_a.password
      click_button 'ログイン'
    end

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
          sleep 0.1
          click_link '優先度'
          sleep 0.1
          expect(task3_i).to be < task2_i
          expect(task2_i).to be < task1_i
        end
      end

      context '優先度のリンクを3回踏んだとき' do
        it '作成日時の降順で表示される' do
          click_link '優先度'
          sleep 0.1
          click_link '優先度'
          sleep 0.1
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
          sleep 0.1
          click_link 'ステータス'
          sleep 0.1
          expect(task3_i).to be < task2_i
          expect(task2_i).to be < task1_i
        end
      end

      context 'ステータスのリンクを3回踏んだとき' do
        it '作成日時の降順で表示される' do
          click_link 'ステータス'
          sleep 0.1
          click_link 'ステータス'
          sleep 0.1
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
          sleep 0.1
          click_link '期限'
          sleep 0.1
          expect(task3_i).to be < task2_i
          expect(task2_i).to be < task1_i
        end
      end

      context '期限のリンクを3回踏んだとき' do
        it '作成日時の降順で表示される' do
          click_link '期限'
          sleep 0.1
          click_link '期限'
          sleep 0.1
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

      context 'ラベルで検索したとき' do
        it '選択したラベルのタスクが表示される' do
          select 'label_1', from: 'search[label]'
          click_button '検索'
          expect(page).to have_content task1_title
          expect(page).to have_no_content task2_title
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

      context '優先度とラベルで検索したとき' do
        it '選択した優先度とラベルのタスクが表示される' do
          select '低', from: 'search[priority]'
          select 'label_1', from: 'search[label]'
          click_button '検索'
          expect(page).to have_content task6_title
          expect(page).to have_no_content task3_title
        end
      end

      context 'ステータスとラベルで検索したとき' do
        it '選択したステータスとラベルのタスクが表示される' do
          select '完了', from: 'search[status]'
          select 'label_2', from: 'search[label]'
          click_button '検索'
          expect(page).to have_content task4_title
          expect(page).to have_no_content task3_title
        end
      end

      context 'ラベルと名称で検索したとき' do
        it '選択したラベルと名称のタスクが表示される' do
          select 'label_2', from: 'search[label]'
          fill_in 'search[title]', with: task2_title
          click_button '検索'
          expect(page).to have_content task2_title
          expect(page).to have_no_content task4_title
        end
      end
    end

    describe 'ページネーション' do
      before do
        (1..100).each { |i|
          FactoryBot.create(:task, title: "ページネーションタスク#{i}", created_at: i.days.ago, user: user_a)
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

    describe '一覧表示' do
      before do
        user_b = FactoryBot.create(:user, name: 'Bさん', email: 'b@example.com')
        FactoryBot.create(:task, title: 'Bさんのタスク', user: user_b)
        visit tasks_path
      end

      it 'Bさんのタスクは表示されない' do
        expect(page).to have_no_content 'Bさんのタスク'
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
        labels
        visit new_task_path
        fill_in 'task_title', with: '新規タスク'
      end

      context 'ラベルを重複せずに選択した場合' do
        before do
          select 'label_1', from: 'task[task_labels_attributes][0][label_id]'
          select 'label_2', from: 'task[task_labels_attributes][1][label_id]'
          select 'label_3', from: 'task[task_labels_attributes][2][label_id]'
          click_button '登録する'
        end

        it 'タスクが新規作成される' do
          expect(page).to have_content '新規タスク'
          tds = page.all('td')
          expect(tds[4]).to have_content 'label_1'
          expect(tds[4]).to have_content 'label_2'
          expect(tds[4]).to have_content 'label_3'
          expect(Task.count).to eq 1
          expect(TaskLabel.count).to eq 3
        end
      end

      context 'ラベルを重複して選択した場合' do
        before do
          select 'label_1', from: 'task[task_labels_attributes][0][label_id]'
          select 'label_1', from: 'task[task_labels_attributes][1][label_id]'
          select 'label_2', from: 'task[task_labels_attributes][2][label_id]'
          click_button '登録する'
        end

        it 'エラーが発生する' do
          expect(page).to have_content I18n.t('alert.duplicate_label')
          expect(Task.count).to eq 0
        end
      end
    end

    describe '編集' do
      before do
        labels
        single_task_label_1
        single_task_label_2
        visit edit_task_path(single_task)
      end

      it '名称が編集される' do
        fill_in 'task_title', with: '編集した'
        click_button '更新する'
        expect(page).to have_content '編集した'
      end

      it 'ラベルを追加できる' do
        select 'label_3', from: 'task[task_labels_attributes][2][label_id]'
        click_button '更新する'
        expect(page).to have_content 'label_3'
        expect(TaskLabel.count).to eq 3
      end

      it 'ラベルをはずすことができる' do
        select '', from: 'task[task_labels_attributes][0][label_id]'
        click_button '更新する'
        tds = page.all('td')
        expect(tds[4]).to_not have_content 'label_1'
        expect(tds[4]).to have_content 'label_2'
        expect(TaskLabel.count).to eq 1
      end

      it 'ラベルを重複して選択するとエラーが発生する' do
        select 'label_1', from: 'task[task_labels_attributes][1][label_id]'
        click_button '更新する'
        expect(page).to have_content I18n.t('alert.duplicate_label')
        expect(TaskLabel.count).to eq 2
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

  describe '非ログイン時の処理' do
    it 'ログインページに戻される' do
      visit tasks_path
      expect(page).to have_content User.human_attribute_name(:password)
      expect(page).to have_no_content I18n.t('headline.task.index')
    end
  end
end

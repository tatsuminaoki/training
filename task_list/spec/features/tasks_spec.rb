# frozen_string_literal: true.
require 'rails_helper'

RSpec.feature 'Tasks', type: :feature do
  background do
    @task = create(:task)
  end
  feature '画面遷移' do
    scenario 'root_pathから投稿ページに遷移すること' do
      visit root_path
      click_link '投稿'
      expect(page).to have_content 'タスク投稿'
    end

    scenario 'root_pathから編集ページに遷移すること' do
      visit root_path
      click_link '詳細'
      click_link '編集'
      expect(page).to have_content '編集画面'
    end

    scenario 'root_pathから削除ページに遷移すること' do
      visit root_path
      click_link '詳細'
      expect(page).to have_content '削除'
    end
  end

  feature 'バリデーション' do
    scenario 'nameが空では登録できない' do
      expect(build(:task, name: '')).to_not be_valid
    end

    scenario 'priorityが空では登録できない' do
      expect(build(:task, priority: '')).to_not be_valid
    end

    scenario 'statusが空では登録できない' do
      expect(build(:task, status: '')).to_not be_valid
    end

    scenario 'nameが31文字以上だと登録できない' do
      expect(build(:task, name: ('a' * 31))).to_not be_valid
    end

    scenario 'nameが空のときにバリデーションエラーメッセージが出ること' do
      visit new_task_path
      fill_in 'タスク名', with: ''
      fill_in '優先順位', with: '1'
      select '未着手', from: 'ステータス'
      click_button '登録する'
      expect(page).to have_content 'タスク名を入力してください'
    end

    scenario 'priorityが空のときにバリデーションエラーメッセージが出ること' do
      visit new_task_path
      fill_in 'タスク名', with: 'Study'
      fill_in '優先順位', with: ''
      select '未着手', from: 'ステータス'
      click_button '登録する'
      expect(page).to have_content '優先順位を入力してください'
    end

    scenario 'nameが31文字以上ときにバリデーションエラーメッセージが出ること' do
      visit new_task_path
      fill_in 'タスク名', with: ('a' * 31)
      fill_in '優先順位', with: '1'
      select '未着手', from: 'ステータス'
      click_button '登録する'
      expect(page).to have_content 'タスク名は30文字以内で入力してください'
    end
  end

  feature 'タスクのCRUD' do
    scenario '新規タスクの作成' do
      visit new_task_path
      fill_in 'タスク名', with: 'Study'
      fill_in '優先順位', with: '1'
      select '未着手', from: 'ステータス'
      click_button '登録する'
      expect(page).to have_content 'タスクを作成しました！'
      expect(page).to have_content 'Study'
    end

    scenario 'タスクの編集' do
      visit "tasks/#{@task.id}/edit"
      fill_in 'タスク名', with: 'English'
      fill_in '優先順位', with: '1'
      select '未着手', from: 'ステータス'
      click_button '更新する'
      expect(page).to have_content 'タスクを編集しました！'
      expect(page).to have_content 'English'
    end

    scenario 'タスクの削除' do
      visit "tasks/#{@task.id}"
      click_link '削除'
      expect(page).to have_content 'タスクを削除しました！'
    end
  end

  feature '検索、ソート機能' do
    scenario 'タスク一覧が作成日時の順番で並ぶこと' do
      create(:task, name: 'Housework', created_at: Time.current + 1.days)
      visit tasks_path
      task = all('table td')
      task1 = task[0]
      expect(task1).to have_content 'Housework'
    end

    scenario 'name,priority,statusがあればタスク投稿ができる' do
      expect(create(:task)).to be_valid
    end

    scenario '一覧画面にて終了期限で降順にソートできること' do
      create(:task, name: 'Housework', endtime: (Time.current + 1.day), created_at: Time.current)
      visit root_path
      click_link '終了時間'
      task = all('table td')
      task1 = task[0]
      expect(task1).to have_content 'Housework'
    end

    scenario '一覧画面にて終了期限で昇順にソートできること' do
      create(:task, name: 'Study', endtime: (Time.current - 1.day), created_at: Time.current)
      visit root_path
      click_link '終了時間'
      click_link '終了時間'
      task = all('table td')
      task1 = task[0]
      expect(task1).to have_content 'Study'
    end

    scenario 'タスク名で検索ができていること' do
      create(:task, name: 'English')
      visit root_path
      fill_in 'タスク名', with: 'English'
      click_button '検索'
      expect(page).to have_content 'English'
      expect(page).not_to have_content 'Task1'
    end

    scenario 'ステータスで検索ができていること' do
      create(:task, name: '着手タスク', status: 1)
      visit root_path
      select '着手', from: 'status'
      click_button '検索'
      expect(page).to have_content '着手タスク'
      expect(page).not_to have_content 'Task1'
    end
  end

  feature 'ページネーション' do
    background do
      15.times{ create(:task) }
    end

    scenario 'ページネーション機能により16件中10件のタスクが最初のページに表示されていること' do
      visit root_path
      # 1件のタスクにつき6個のtdがある
      expect(all('tr td').size).to eq(60)
    end

    scenario 'ページネーション機能により16件中6件のタスクが2ページ目に表示されていること' do
      visit root_path
      click_link '次 ›'
      # 1件のタスクにつき6個のtdがある
      expect(all('tr td').size).to eq(36)
    end
  end
end

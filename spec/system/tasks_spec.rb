# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Tasks', type: :system do
  let(:user) { create(:user) }

  specify 'User operates from creation to editing to deletion' do
    user_login(user: user)

    visit root_path

    expect(page).to have_content('タスク管理')

    click_on '新規'

    fill_in 'タスク名', with: 'task name'
    fill_in '説明', with: 'hoge'
    select '着手', from: 'ステータス'
    select '映画', from: 'task[label_ids][]'

    click_on '登録する'

    expect(page).to have_content('タスクの登録が完了しました。')
    expect(page).to have_content('task name')
    expect(page).to have_content('hoge')
    expect(page).to have_content('着手')
    expect(page).to have_content('映画')

    click_on '編集'

    expect(page).to have_content('タスク編集')
    fill_in 'タスク名', with: 'update'
    fill_in '説明', with: 'hoge-update'
    select '完了', from: 'ステータス'
    select '旅行', from: 'task[label_ids][]'

    click_on '更新する'

    expect(page).to have_content('タスクの更新が完了しました。')
    expect(page).to have_content('update')
    expect(page).to have_content('hoge-update')
    expect(page).to have_content('完了')
    expect(page).to have_content('映画')
    expect(page).to have_content('旅行')

    click_on '戻る'

    expect(page).to have_content('タスク管理')
    expect(page).to have_content('update')
    expect(page).to have_content('hoge-update')
    expect(page).to have_content('完了')
  end

  context '一覧表示' do
    before do
      create(:task, { name: 'task1', created_at: Time.zone.now, finished_on: 1.day.since.to_date, user: user })
      create(:task, { name: 'task2', created_at: 1.day.ago, finished_on: Date.current, user: user })
    end

    scenario '一覧の初期表示のソート順が登録日の降順であること' do
      user_login(user: user)

      visit root_path

      tds = page.all('td')
      expect(tds[0]).to have_content 'task1'
      expect(tds[9]).to have_content 'task2'
    end

    scenario '一覧のソート順が終了期限の昇順/降順と切り替わること' do
      user_login(user: user)

      visit root_path

      click_on '▲'

      tds = page.all('td')
      expect(tds[0]).to have_content 'task2'

      click_on '▼'

      tds = page.all('td')
      expect(tds[0]).to have_content 'task1'
    end
  end

  context '一覧検索' do
    before do
      create(:task, { name: 'task_name_1', user: user })
      create(:task, { name: 'task_name_2', status: :work_in_progress, user: user })

      user.tasks.first.task_labels.create!(label_id: Label.pluck(:id).first)
    end

    scenario '検索項目に入力なしで検索できること' do
      user_login(user: user)

      visit root_path

      click_on '検索'

      expect(page).to have_content('task_name_1')
      expect(page).to have_content('task_name_2')
    end

    scenario 'タスク名で検索できること' do
      user_login(user: user)

      visit root_path

      fill_in 'name', with: 'task_name_1'

      click_on '検索'

      expect(page).to have_content('task_name_1')
      expect(page).to_not have_content('task_name_2')
    end

    scenario 'ステータスで検索できること' do
      user_login(user: user)

      visit root_path

      select '着手', from: 'status'

      click_on '検索'

      expect(page).to have_content('task_name_2')
      expect(page).to_not have_content('task_name_1')
    end

    scenario 'タスク名とステータスで検索できること' do
      user_login(user: user)

      visit root_path

      fill_in 'name', with: 'task_name_2'
      select '着手', from: 'status'

      click_on '検索'

      expect(page).to have_content('task_name_2')
      expect(page).to_not have_content('task_name_1')
    end

    scenario 'タスク名とステータスとラベル名で検索できること' do
      user_login(user: user)

      visit root_path

      fill_in 'name', with: 'task_name_1'
      select '未着手', from: 'status'
      select 'ジム', from: 'label_ids[]'

      click_on '検索'

      expect(page).to have_content('task_name_1')
      expect(page).to have_content('未着手')
      expect(page).to have_content('ジム')
      expect(page).to_not have_content('task_name_2')
    end
  end
end

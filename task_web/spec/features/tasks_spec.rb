# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'タスク管理一覧画面', type: :feature do
  # 初期データ作成
  context '初期表示' do
    let!(:init_tasks) {
      [
        create(:task, { name: 'name1', due_date: '2019-12-31', priority: :high, user_id: 1, status: :closed, created_at: Time.zone.now }),
        create(:task, { name: 'name2', due_date: '2020-12-31', priority: :low, user_id: 1, status: :in_progress, created_at: 1.minute.ago }),
        create(:task, { name: 'name3', due_date: '2018-12-31', priority: :normal, user_id: 1, status: :open, created_at: 2.minutes.ago }),
      ]
    }
    scenario 'タスク一覧の表示確認' do
      visit root_path
      init_tasks.each do |task|
        expect(page).to have_content task.name
        expect(page).to have_content task.description
        expect(Task.count).to eq(3)
      end
    end
    scenario 'タスク一覧のデフォルトソート順（登録日時、降順）の確認' do
      visit root_path
      names = page.all('td.name')
      expect(names[0]).to have_content 'name1'
      expect(names[1]).to have_content 'name2'
      expect(names[2]).to have_content 'name3'
    end
    scenario 'タスク一覧のソート順（期限、降順）の確認' do
      visit tasks_path(order_by: 'due_date', order: 'ASC')
      names = page.all('td.name')
      expect(names[0]).to have_content 'name3'
      expect(names[1]).to have_content 'name1'
      expect(names[2]).to have_content 'name2'
    end
    scenario 'タスク一覧のソート順（期限、昇順）の確認' do
      visit tasks_path(order_by: 'due_date', order: 'DESC')
      names = page.all('td.name')
      expect(names[0]).to have_content 'name2'
      expect(names[1]).to have_content 'name1'
      expect(names[2]).to have_content 'name3'
    end
    scenario 'タスク一覧のソート順（優先度、降順）の確認' do
      visit tasks_path(order_by: 'priority', order: 'ASC')
      names = page.all('td.name')
      expect(names[0]).to have_content 'name2'
      expect(names[1]).to have_content 'name3'
      expect(names[2]).to have_content 'name1'
    end
    scenario 'タスク一覧のソート順（優先度、昇順）の確認' do
      visit tasks_path(order_by: 'priority', order: 'DESC')
      names = page.all('td.name')
      expect(names[0]).to have_content 'name1'
      expect(names[1]).to have_content 'name3'
      expect(names[2]).to have_content 'name2'
    end
    scenario 'タスク一覧のソート順（登録日時、降順）の確認' do
      visit tasks_path(order_by: 'created_at', order: 'ASC')
      names = page.all('td.name')
      expect(names[0]).to have_content 'name3'
      expect(names[1]).to have_content 'name2'
      expect(names[2]).to have_content 'name1'
    end
    scenario 'タスク一覧のソート順（登録日時、昇順）の確認' do
      visit tasks_path(order_by: 'created_at', order: 'DESC')
      names = page.all('td.name')
      expect(names[0]).to have_content 'name1'
      expect(names[1]).to have_content 'name2'
      expect(names[2]).to have_content 'name3'
    end
  end
end
RSpec.feature 'タスク管理 機能テスト(遷移・更新系)', type: :feature do
  let!(:init_task) { create(:task) }
  context '画面遷移テスト' do
    scenario 'タスクの登録画面への遷移確認' do
      visit root_path
      click_on('タスクを追加する')
      expect(current_path).to eq new_task_path
      expect(page).to have_field 'task_name', with: ''
      expect(page).to have_field 'task_description', with: ''
    end
    scenario 'タスクの更新画面への遷移確認' do
      visit root_path
      click_link '編集', match: :first
      expect(current_path).to eq edit_task_path(init_task)
      expect(page).to have_field 'task_name', with: init_task.name
      expect(page).to have_field 'task_description', with: init_task.description
    end
  end
  context '登録・更新・削除テスト' do
    let(:added_task) { build(:task, { name: 'ゴミ出し', description: '粗大ゴミ出す' }) }
    let(:updated_task) { build(:task, { name: '家事', description: 'トイレ掃除' }) }
    scenario 'タスクの登録確認' do
      visit new_task_path
      expect {
        fill_in 'task_name', with: added_task.name
        fill_in 'task_description', with: added_task.description
        click_on('Create タスク')
      }.to change { Task.count }.by(1)
      expect(current_path).to eq tasks_path
      expect(page).to have_content 'タスクの登録に成功しました。'
      expect(page).to have_content added_task.name
      expect(page).to have_content added_task.description
    end
    scenario 'タスクの更新確認' do
      visit edit_task_path(init_task)
      expect {
        fill_in 'task_name', with: updated_task.name
        fill_in 'task_description', with: updated_task.description
        click_on('Update タスク')
      }.to change { Task.count }.by(0)
      expect(current_path).to eq tasks_path
      expect(page).to have_content 'タスクの更新に成功しました。'
      expect(page).to_not have_content init_task.name
      expect(page).to_not have_content init_task.description
      expect(page).to have_content updated_task.name
      expect(page).to have_content updated_task.description
      init_task.reload
      expect(init_task.name).to eq updated_task.name
      expect(init_task.description).to eq updated_task.description
    end
    scenario 'タスクの削除確認' do
      visit root_path
      expect {
        click_link '削除', match: :first
        page.accept_confirm "#{init_task.name}を削除しますか？"
        expect(current_path).to eq tasks_path
      }.to change { Task.count }.by(-1)
      expect(page).to have_content 'タスクの削除に成功しました。'
    end
  end
end
RSpec.feature 'タスク管理 機能テスト(検索系)', type: :feature do
  context '検索・絞り込み機能テスト' do
    let!(:init_tasks) {
      [
        create(:task, { name: 'name1', due_date: '2019-12-31', priority: :high, user_id: 1, status: :closed, created_at: Time.zone.now }),
        create(:task, { name: 'name2', due_date: '2020-12-31', priority: :low, user_id: 1, status: :in_progress, created_at: 1.minute.ago }),
        create(:task, { name: 'name3', due_date: '2018-12-31', priority: :normal, user_id: 1, status: :open, created_at: 2.minutes.ago }),
      ]
    }
    scenario 'タスク名で検索 1件HIT' do
      visit root_path
      fill_in 'name', with: init_tasks[0].name
      click_on('Search')
      expect(current_path).to eq tasks_path()
      expect(page).to have_content('name', count: 1)
      expect(page).to have_content('name1', count: 1)
    end
    scenario 'タスク名で検索 複数件HIT' do
      visit root_path
      fill_in 'name', with: 'name'
      click_on('Search')
      expect(current_path).to eq tasks_path()
      expect(page).to have_content('name1', count: 1)
      expect(page).to have_content('name2', count: 1)
      expect(page).to have_content('name3', count: 1)
    end
    scenario 'タスク名で検索 0件HIT' do
      visit root_path
      fill_in 'name', with: 'no_hit_task'
      click_on('Search')
      expect(current_path).to eq tasks_path()
      expect(page).not_to have_content 'name'
    end
    scenario 'ステータスで絞り込み' do
      visit root_path
      select '着手中', from: 'status'
      click_on('Search')
      expect(current_path).to eq tasks_path()
      expect(page).to have_content('name', count: 1)
      expect(page).to have_content('name2', count: 1)
    end
    scenario 'タスク名とステータスで検索' do
      visit root_path
      fill_in 'name', with: 'na'
      select '未着手', from: 'status'
      click_on('Search')
      expect(current_path).to eq tasks_path()
      expect(page).to have_content('name', count: 1)
      expect(page).to have_content('name3', count: 1)
    end
  end
end

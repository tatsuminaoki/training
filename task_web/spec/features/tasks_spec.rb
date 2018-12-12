# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'タスク管理ツール フィーチャテスト', type: :feature do
  # 初期データ作成
  let!(:init_task) { create(:task) }

  # TODO: ページングの確認, 検索・絞り込み機能の確認など、都度追加します。
  # TODO: Validation関連のテストは、ステップ11で実装予定。
  scenario '#タスク一覧の表示確認' do
    visit root_path
    expect(page).to have_content init_task.name
    expect(page).to have_content init_task.description
  end

  scenario '#タスクの登録画面への遷移確認' do
    visit root_path
    click_on('タスク追加')
    expect(current_path).to eq new_task_path
    expect(page).to have_field 'task_name', with: ''
    expect(page).to have_field 'task_description', with: ''
  end

  let(:added_task) { build(:task, { name: 'ゴミ出し', description: '粗大ゴミ出す' }) }
  scenario '#タスクの登録確認' do
    visit new_task_path
    expect {
      fill_in 'task_name', with: added_task.name
      fill_in 'task_description', with: added_task.description
      click_on('Create Task')
    }.to change { Task.count }.by(1)
    expect(current_path).to eq tasks_path
    expect(page).to have_content 'タスクを登録しました'
    expect(page).to have_content added_task.name
    expect(page).to have_content added_task.description
  end

  scenario '#タスクの更新画面への遷移確認' do
    visit root_path
    click_link '編集', match: :first
    expect(current_path).to eq edit_task_path(init_task)
    expect(page).to have_field 'task_name', with: init_task.name
    expect(page).to have_field 'task_description', with: init_task.description
  end

  let(:updated_task) { build(:task, { name: '家事', description: 'トイレ掃除' }) }
  scenario '#タスクの更新確認' do
    visit edit_task_path(init_task)
    expect {
      fill_in 'task_name', with: updated_task.name
      fill_in 'task_description', with: updated_task.description
      click_on('Update Task')
    }.to change { Task.count }.by(0)
    expect(current_path).to eq tasks_path
    expect(page).to have_content 'タスクを更新しました'
    expect(page).to_not have_content init_task.name
    expect(page).to_not have_content init_task.description
    expect(page).to have_content updated_task.name
    expect(page).to have_content updated_task.description
    init_task.reload
    expect(init_task.name).to eq updated_task.name
    expect(init_task.description).to eq updated_task.description
  end

  scenario '#タスクの削除確認' do
    visit root_path
    expect {
      click_link '削除', match: :first
      page.accept_confirm 'タスクを削除しても良いですか？'
      expect(current_path).to eq tasks_path
    }.to change { Task.count }.by(-1)
    expect(page).to have_content 'タスクを削除しました'
  end
end

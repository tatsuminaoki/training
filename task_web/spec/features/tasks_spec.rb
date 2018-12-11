# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'タスク管理ツール フィーチャテスト', type: :feature do
  before do
    # タスクデータ作成
    @task = FactoryBot.create(:task)
  end
  # TODO: ページングの確認, 検索・絞り込み機能の確認など、都度追加します。
  # TODO: Validation関連のテストは、ステップ11で実装予定。
  scenario '#タスク一覧の表示確認' do
    visit root_path
    expect(page).to have_content '買い物'
    expect(page).to have_content '日用品を買い揃える'
  end
  scenario '#タスクの登録確認' do
    visit root_path
    click_on('タスク追加')
    fill_in 'task_name', with: 'ゴミ出し'
    fill_in 'task_description', with: '粗大ゴミ出す'
    expect {
      click_on('Create Task')
      expect(page).to have_content 'タスクを登録しました'
      expect(page).to have_content 'ゴミ出し'
      expect(page).to have_content '粗大ゴミ出す'
    }.to change { Task.count }.by(1)
  end
  scenario '#タスクの更新確認' do
    visit edit_task_path(@task)
    expect(page).to have_field 'task_name', with: '買い物'
    expect(page).to have_field 'task_description', with: '日用品を買い揃える'
    fill_in 'task_name', with: 'ゴミ出し'
    fill_in 'task_description', with: '粗大ゴミ出す'
    expect {
      click_on('Update Task')
      expect(page).to have_content 'タスクを更新しました'
      expect(page).to_not have_content '買い物'
      expect(page).to_not have_content '日用品を買い揃える'
      expect(page).to have_content 'ゴミ出し'
      expect(page).to have_content '粗大ゴミ出す'
    }.to change { Task.count }.by(0)
  end
  scenario '#タスクの削除確認' do
    visit root_path
    click_link '削除', match: :first
    expect {
      page.accept_confirm 'タスクを削除しても良いですか？'
      expect(page).to have_content 'タスクを削除しました'
    }.to change { Task.count }.by(-1)
  end
end

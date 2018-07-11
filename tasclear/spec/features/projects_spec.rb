require 'rails_helper'

RSpec.feature "Tasts", type: :feature do
  scenario '新しいタスクを作成する' do
    expect {
      visit root_path
      click_link '新規タスク登録'
      fill_in 'Name', with: '勉強'
      fill_in 'Content', with: 'RSpecについて'
      click_button 'Create Task'
      expect(page).to have_content 'タスクを作成しました'
      expect(page).to have_content '勉強'
      expect(page).to have_content 'RSpecについて'
    }.to change(Task.all, :count).by(1)
  end
  scenario 'タスクを編集する' do
      visit root_path
      click_link '新規タスク登録'
      fill_in 'Name', with: '勉強'
      fill_in 'Content', with: 'RSpecについて'
      click_button 'Create Task'
      expect {
        click_link '編集'
        fill_in 'Name', with: '運動'
        fill_in 'Content', with: '腕立て100回'
        click_button 'Update Task'
      expect(page).to have_content 'タスクを編集しました'
      expect(page).to have_content '運動'
      expect(page).to have_content '腕立て100回'
    }.to change(Task.all, :count).by(0)
  end
  scenario 'タスクを削除する' do
      visit root_path
      click_link '新規タスク登録'
      fill_in 'Name', with: '勉強'
      fill_in 'Content', with: 'RSpecについて'
      click_button 'Create Task'
      expect {
        click_link '削除'
      expect(page).to have_content 'タスクを削除しました'
    }.to change(Task.all, :count).by(-1)
  end
end

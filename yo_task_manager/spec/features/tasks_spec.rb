require 'rails_helper'

RSpec.feature 'Tasks', type: :feature do
  scenario 'user visit tasks index/root' do
    visit '/tasks'
    expect(page).to have_text('タスク一覧')
    visit '/'
    expect(page).to have_text('タスク一覧')
  end

  scenario 'user create new task' do
    visit '/'
    expect(page).to have_button('タスク追加')
    click_button 'タスク追加'
    expect(page).to have_text('タスク追加')
    expect(page).to have_button('追加')
    fill_in 'task[title]', with: 'タスク1'
    fill_in 'task[body]', with: 'タスク1の詳細です。'
    click_button '追加'
    expect(page).to have_text('タスク1')
    expect(page).to have_text('タスク1の詳細です。')
  end
end

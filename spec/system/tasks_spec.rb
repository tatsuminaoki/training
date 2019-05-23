# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Tasks', type: :system do
  specify 'User operates from creation to editing to deletion' do
    visit root_path

    expect(page).to have_content('Tasks')

    click_on 'New Task'

    fill_in 'タスク名', with: 'task name'
    fill_in '説明', with: 'hoge'
    select 'work_in_progress', from: 'ステータス'

    click_on '登録する'

    expect(page).to have_content('タスクの登録が完了しました。')
    expect(page).to have_content('task name')
    expect(page).to have_content('hoge')
    expect(page).to have_content('work_in_progress')

    click_on 'Edit'

    expect(page).to have_content('Editing Task')
    fill_in 'タスク名', with: 'update'
    fill_in '説明', with: 'hoge-update'
    select 'completed', from: 'ステータス'

    click_on '更新する'

    expect(page).to have_content('タスクの更新が完了しました。')
    expect(page).to have_content('update')
    expect(page).to have_content('hoge-update')
    expect(page).to have_content('completed')

    click_on 'Back'

    expect(page).to have_content('Tasks')
    expect(page).to have_content('update')
    expect(page).to have_content('hoge-update')
    expect(page).to have_content('completed')
  end
end

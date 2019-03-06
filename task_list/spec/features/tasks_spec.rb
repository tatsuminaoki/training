require 'rails_helper'

RSpec.feature "Tasks", type: :feature do
  background do
    @task = create(:task)
  end
  scenario 'root_pathから投稿ページに遷移すること' do
    visit root_path
    click_link '投稿'
    expect(page).to have_content 'タスク投稿'
  end
  scenario '新規タスクの作成' do
    visit new_task_path
    fill_in 'タスク名', with: 'Study'
    fill_in '優先順位', with: '1'
    fill_in 'ステータス', with: '1'
    click_button '登録する'
    expect(page).to have_content 'タスクを作成しました！'
    expect(page).to have_content 'Study'
  end
  scenario 'root_pathから編集ページに遷移すること' do
    visit root_path
    click_link '詳細'
    click_link '編集'
    expect(page).to have_content '編集画面'
  end
  scenario 'タスクの編集' do
    visit "tasks/#{@task.id}/edit"
    fill_in 'タスク名', with: 'English'
    fill_in '優先順位', with: '1'
    fill_in 'ステータス', with: '1'
    click_button '更新する'
    expect(page).to have_content 'タスクを編集しました！'
    expect(page).to have_content 'English'
  end
  scenario 'root_pathから削除ページに遷移すること' do
    visit root_path
    click_link '詳細'
    expect(page).to have_content '削除'
  end
  scenario 'タスクの削除' do
    visit "tasks/#{@task.id}"
    click_link '削除'
    expect(page).to have_content 'タスクを削除しました！'
  end
  scenario 'タスク一覧が作成日時の順番で並ぶこと' do
    create(:task, name: 'Housework', created_at: Time.current + 1.days)
    visit tasks_path
    task = all('table td')
    task_0 = task[0]
    expect(task_0).to have_content 'Housework'
  end
end
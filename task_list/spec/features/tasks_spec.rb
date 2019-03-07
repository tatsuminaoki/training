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
  scenario 'name,priority,statusがあればタスク投稿ができる' do
    expect(create(:task)).to be_valid
  end
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
    expect(build(:task, name: "#{'a'*31}")).to_not be_valid
  end
  scenario 'nameが空のときにバリデーションエラーメッセージが出ること' do
    task = build(:task, name: '')
    task.valid?
    expect(task.errors.messages[:name]).to include 'を入力してください'
  end
  scenario 'priorityが空のときにバリデーションエラーメッセージが出ること' do
    task = build(:task, priority: '')
    task.valid?
    expect(task.errors.messages[:priority]).to include 'を入力してください'
  end
  scenario 'atatusが空のときにバリデーションエラーメッセージが出ること' do
    task = build(:task, status: '')
    task.valid?
    expect(task.errors.messages[:status]).to include 'を入力してください'
  end
  scenario 'nameが31文字以上ときにバリデーションエラーメッセージが出ること' do
    task = build(:task, name: "#{'a'*31}")
    task.valid?
    expect(task.errors.messages[:name]).to include 'は30文字以内で入力してください'
  end
end
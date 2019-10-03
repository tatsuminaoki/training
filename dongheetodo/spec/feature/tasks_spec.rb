require 'rails_helper'

RSpec.feature "Tasks", type: :feature, js: true do

  given!(:user) { create(:user, :with_tasks) }

  scenario "タスク一覧を表示する", open_on_error: true do
    visit tasks_path
    expect(page).to have_content "タスク一覧"
  end

  scenario "タスクを作成する", open_on_error: true do
    visit new_task_path
    fill_in "task_name", with: "ダミーデータ"
    fill_in "task_description", with: "ダミー内容"
    select "完了", from: "task_status"
    select "中", from: "task_priority"
    click_button "登録する"
    expect(page).to have_content "正常に作成しました"
  end

  scenario "タスク詳細を表示する", open_on_error: true do
    visit root_path
    all("tbody tr ")[0].click_link "詳細"
    expect(page).to have_content "タスク詳細"
  end

  scenario "タスクを更新する", open_on_error: true do
    visit root_path
    all("tbody tr ")[0].click_link "修正"
    fill_in "task_name", with: "更新するよー"
    fill_in "task_description", with: "テストのため更新します"
    select "未着手", from: "task_status"
    select "低", from: "task_priority"
    click_button "更新する"
    expect(page).to have_content "正常に更新しました"
  end

  scenario "タスクを削除する", open_on_error: true do
    visit tasks_path
    all("tbody tr ")[0].click_link "削除"
    accept_alert "本当に削除しますか？"
    expect(page).to have_content "正常に削除しました"
  end

  scenario "タスク一覧の並び順を作成日の降順にする" do
    visit tasks_path
    all("thead th")[5].click_link "created_at_sort_desc"
    save_and_open_page
    expect(page).to have_link "created_at_sort_asc"
  end

  scenario "タスク一覧の並び順を作成日の昇順にする（元に戻す）" do
    visit tasks_path
    all("thead th")[5].click_link "created_at_sort_desc"
    all("thead th")[5].click_link "created_at_sort_asc"
    save_and_open_page
    expect(page).to have_link "created_at_sort_desc"
  end
end

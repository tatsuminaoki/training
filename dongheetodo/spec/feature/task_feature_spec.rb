require 'rails_helper'

RSpec.feature "[タスクCRUD]", js: true do
  background do
    # TODO: ログイン機能追加後、user_idを動的に当てるように修正
    @user = User.create!(id: 1, email: "donghee_kim@fablic.co.jp", password_digest: "hogehoge")
    @task = Task.create!(user_id: @user.id, name: "hoge", description: "hogehoge",
                         priority: Task.priorities[:中], status: Task.statuses[:完了])
  end
  scenario "タスク一覧を表示する" do
    visit tasks_path
    expect(page).to have_content "タスク一覧"
  end
  scenario "タスクを作成する" do
    visit new_task_path
    fill_in "task_name", with: "ダミーデータ"
    fill_in "task_description", with: "ダミー内容"
    select "完了", from: "task_status"
    select "中", from: "task_priority"
    click_button "Create Task"
    expect(page).to have_content "正常に作成しました"
  end
  scenario "タスク詳細を表示する" do
    visit task_path(@task.id)
    expect(page).to have_content "タスク詳細"
  end
  scenario "タスクを更新する" do
    visit edit_task_path(@task.id)
    fill_in "task_name", with: "更新するよー"
    fill_in "task_description", with: "テストのため更新します"
    select "未着手", from: "task_status"
    select "低", from: "task_priority"
    click_button "Update Task"
    expect(page).to have_content "正常に更新しました"
  end
  scenario "タスクを削除する" do
    visit tasks_path
    all("tbody tr ")[0].click_link "削除"
    accept_alert "本当に削除しますか？"
    expect(page).to have_content "正常に削除しました"
  end
end
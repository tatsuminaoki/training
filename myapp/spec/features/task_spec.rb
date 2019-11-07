require 'rails_helper'

RSpec.feature "Task management", type: :feature do
  scenario "User creates a new task" do
    visit new_task_path

    fill_in "名前", with: "My Task"
    fill_in "説明", with: "説明"
    click_button "送信"

    expect(page).to have_text("新しいタスクが作成されました！")
  end

  scenario "User edits a task." do
    name = 'mytask-spec'
    task = Task.create(name: name, description: 'tmp')
    visit edit_task_path(task)

    # check if in the right place.
    expect(page).to have_selector("input[value=#{name}]")

    name_edited = 'mytask-spec-edited'
    fill_in "名前", with: name_edited
    click_button "送信"

    # check if updates successfully.
    expect(page).to have_text("タスクが更新されました！")
    expect(page).to have_text(name_edited)
  end

  scenario "User delete a task on detail page." do
    name = 'task-to-delete'
    task = Task.create(name: name, description: 'tmp')
    visit task_path(task)

    click_link "削除"

    expect(page).to have_text("タスクを削除しました！")
    expect(page).not_to have_text(name)
  end

  scenario "User lists tasks" do
    name = 'task-to-list'
    task = Task.create(name: name, description: 'tmp')
    visit root_path

    expect(page).to have_text(name)
  end
end

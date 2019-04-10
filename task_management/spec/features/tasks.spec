require "rails_helper"

RSpec.feature "task_test", :type => :feature do

  before do
    params = {
      :task_name => "feature test task",
      :contents => "feature test contents"
    }

    @task = Task.new(params)
    @task.save
  end

  scenario "Create new task" do

    visit "/"
    click_link "新規作成"
    fill_in "task[task_name]", :with => "featureテスト"
    fill_in "task[contents]", :with => "featureテスト中です。"
    click_button "Create Task"
    expect(page).to have_text("新規タスクを追加しました")
    expect(page).to have_link(@task.task_name)
    expect(page).to have_text(@task.contents)

  end

  scenario "edit task" do

    visit "/"
    click_link @task.task_name
    click_link "修正"
    fill_in "task[task_name]", :with => "featureテスト edited!!"
    fill_in "task[contents]", :with => "featureテスト進行中!"
    expect(page).to have_link("削除")
    click_button "Update Task"
    expect(page).to have_text("タスクを編集しました")

  end

  scenario "delete task" do

    visit "/tasks/#{@task.id}/edit"
    expect(page).to have_field "task[task_name]", with: @task.task_name
    expect(page).to have_field "task[contents]", with: @task.contents

    expect(page).to have_button("Update Task")

    click_link "削除"
    expect(page).to have_text("タスクを削除しました")

  end

end

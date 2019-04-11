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
    click_link(I18n.t("view.index.new"))
    fill_in "task[task_name]", :with => "featureテスト"
    fill_in "task[contents]", :with => "featureテスト中です。"
    click_button(I18n.t("helpers.submit.create"))
    expect(page).to have_text("新規タスクを追加しました")
    expect(page).to have_link(@task.task_name)
    expect(page).to have_text(@task.contents)

  end

  scenario "edit task" do

    visit "/"
    click_link @task.task_name
    click_link(I18n.t("view.show.go_edit"))
    fill_in "task[task_name]", :with => "featureテスト edited!!"
    fill_in "task[contents]", :with => "featureテスト進行中!"
    expect(page).to have_link(I18n.t("view.edit.delete"))
    click_button(I18n.t("helpers.submit.update"))
    expect(page).to have_text("タスクを編集しました")

  end

  scenario "delete task" do

    visit "/tasks/#{@task.id}/edit"
    expect(page).to have_field "task[task_name]", with: @task.task_name
    expect(page).to have_field "task[contents]", with: @task.contents

    expect(page).to have_button((I18n.t("helpers.submit.update")))

    click_link(I18n.t("view.edit.delete"))
    expect(page).to have_text("タスクを削除しました")

  end

  scenario "validation creating new task" do

    max_string = "a" * 256

    visit "/"
    click_link(I18n.t("view.index.new"))
    fill_in "task[task_name]", :with => ""
    fill_in "task[contents]", :with => "test contents"
    click_button(I18n.t("helpers.submit.create"))
    expect(page).to have_text(I18n.t("activerecord.attributes.task.task_name") + "は必須入力です")

    fill_in "task[task_name]", :with => "バリデーションテスト"
    fill_in "task[contents]", :with => ""
    click_button(I18n.t("helpers.submit.create"))
    expect(page).to have_text(I18n.t("activerecord.attributes.task.contents") + "は必須入力です")

    fill_in "task[task_name]", :with => max_string
    fill_in "task[contents]", :with => "test contents"
    click_button(I18n.t("helpers.submit.create"))
    expect(page).to have_text(I18n.t("activerecord.attributes.task.task_name") + "は255文字以内で入力してください")

    fill_in "task[task_name]", :with => "バリデーションテスト"
    fill_in "task[contents]", :with => max_string
    click_button(I18n.t("helpers.submit.create"))
    expect(page).to have_text(I18n.t("activerecord.attributes.task.contents") + "は255文字以内で入力してください")
  end

end

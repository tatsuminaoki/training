require "rails_helper"

# 日本語表記用変数
word_create_button = "登録する"
word_move_create_task_link = "新規作成"
word_move_edit_task_link = "修正"
word_change_task_button = "更新する"
word_delete_task_link = "削除"

RSpec.feature "task_test", :type => :feature do

  before do
    # 今回はinsertが三件なので、activerecord-importを
    # インストールせずに処理する
    status_master_params = [
      {:id => 1, :status_name => "未着手"},
      {:id => 2, :status_name => "着手中"},
      {:id => 3, :status_name => "完了"}
    ]

    status_master_params.each { |status_params|
      @status = Status.new(status_params)
      @status.save
    }

    # タスクデータ挿入
    status_id = 1
    params = {
      :task_name => "feature test task",
      :contents => "feature test contents",
      :status_id => status_id
    }

    @task = Task.new(params)
    @task.save
  end

  scenario "Create new task" do

    visit "/"
    click_link(word_move_create_task_link)
    fill_in "task[task_name]", :with => "featureテスト"
    fill_in "task[contents]", :with => "featureテスト中です。"
    select '完了', from: 'task_status_id'
    click_button(word_create_button)
    expect(page).to have_text("新規タスクを追加しました")
    expect(page).to have_link(@task.task_name)
    expect(page).to have_text(@task.contents)

  end

  scenario "edit task" do

    visit "/"
    click_link @task.task_name
    click_link(word_move_edit_task_link)
    fill_in "task[task_name]", :with => "featureテスト edited!!"
    fill_in "task[contents]", :with => "featureテスト進行中!"
    expect(page).to have_link(word_delete_task_link)
    click_button(word_change_task_button)
    expect(page).to have_text("タスクを編集しました")

  end

  scenario "delete task" do

    visit "/tasks/#{@task.id}/edit"
    expect(page).to have_field "task[task_name]", with: @task.task_name
    expect(page).to have_field "task[contents]", with: @task.contents

    expect(page).to have_button(word_change_task_button)

    click_link(word_delete_task_link)
    expect(page).to have_text("タスクを削除しました")

  end

  scenario "validation creating new task" do

    max_string = "a" * 256

    visit "/"
    click_link(word_move_create_task_link)
    fill_in "task[task_name]", :with => ""
    fill_in "task[contents]", :with => "test contents"
    click_button(word_create_button)
    expect(page).to have_text(I18n.t("activerecord.attributes.task.task_name") + "は必須入力です")

    fill_in "task[task_name]", :with => "バリデーションテスト"
    fill_in "task[contents]", :with => ""
    click_button(word_create_button)
    expect(page).to have_text(I18n.t("activerecord.attributes.task.contents") + "は必須入力です")

    fill_in "task[task_name]", :with => max_string
    fill_in "task[contents]", :with => "test contents"
    click_button(word_create_button)
    expect(page).to have_text(I18n.t("activerecord.attributes.task.task_name") + "は255文字以内で入力してください")

    fill_in "task[task_name]", :with => "バリデーションテスト"
    fill_in "task[contents]", :with => max_string
    click_button(word_create_button)
    expect(page).to have_text(I18n.t("activerecord.attributes.task.contents") + "は255文字以内で入力してください")

    fill_in "task[task_name]", :with => "feature test task"
    fill_in "task[contents]", :with => "test test"
    click_button(word_create_button)
    expect(page).to have_text(I18n.t("validates.unique"))
  end

  scenario "search task" do

    visit "/"
    fill_in "name", :with => @task.task_name
    click_button(I18n.t("view.index.filter"))
    expect(page).to have_text @task.task_name
  end

end

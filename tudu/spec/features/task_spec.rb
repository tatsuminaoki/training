require "rails_helper"

RSpec.feature "task management", :type => :feature do

  scenario "End User Create a new task" do

    visit new_task_path

    input_name = "タスク名1"
    input_content = "タスク内容1"
    fill_in "task[name]", with: input_name
    fill_in "task[content]", with: input_content
    click_button "登録"
    expect(page).to have_text("タスクを登録しました")

    expect(page).to have_text(input_name)
    expect(page).to have_text(input_content)
  end

  scenario "end user update a task" do

    task = create(:task)
    visit root_path
    expect(page).to have_text(task.name)
    expect(page).to have_text(task.content)

    visit edit_task_path(task)

    input_name = "タスク名1 update"
    input_content = "タスク内容1 update"
    fill_in "task[name]", with: input_name
    fill_in "task[content]", with: input_content
    click_button "変更を保存する"
    expect(page).to have_text("タスクを保存しました")

    expect(page).to have_text(input_name)
    expect(page).to have_text(input_content)
  end

  scenario "end user show a task" do

    task = create(:task)
    visit task_path(task)
    expect(page).to have_text(task.name)
    expect(page).to have_text(task.content)

  end

  scenario "end user view task list and delete" do

    task1 = create(:task)
    task2 = create(
      :task,
      name: "dummy2 name",
      content: "dummy2 content"
    )
    visit tasks_url
    expect(page).to have_text(task1.name)
    expect(page).to have_text(task1.content)
    expect(page).to have_text(task2.name)
    expect(page).to have_text(task2.content)

    click_link("削除", match: :first)
    expect(page).to have_text("タスクを削除しました")

    expect(page).to have_text(task2.name)
    expect(page).to have_text(task2.content)

    expect(page).not_to have_text(task1.name)
    expect(page).not_to have_text(task1.content)

    today = Time.zone.now
    # 並び順のテスト
    10.times do |i|
      params = {
        :name => "name_#{i}",
        :content => "content_#{i}",
        :created_at => today
      }
      @task = Task.new(params)
      @task.save
      today = today + 10
    end
    visit "/"
    first_row = @task
    expect(page.all("tr")[1].text).to include first_row.name

  end

end

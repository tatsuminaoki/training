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

  scenario "end user view task list and sort" do
    today = Time.zone.now
    expire_date = Time.zone.today
    task = nil
    5.times do |i|
      task = create(
        :task,
        name: "name_#{i}",
        content: "content_#{i}",
        created_at: today,
        expire_date: expire_date
      )
      today = today + 10
      expire_date = expire_date + 3
    end

    # task に入っているのは、終了期限が一番後
    visit root_path
    last_expire_date_task = task
    # 昇順
    click_link("終了期限")
    expect(page.all("tr")[5].text).to include last_expire_date_task.name

    # 降順
    click_link("終了期限")
    expect(page.all("tr")[1].text).to include last_expire_date_task.name

  end

  scenario "end user search task" do
    today = Time.zone.now
    expire_date = Time.zone.today

    10.times do |i|
      params = {
        :name => "name_#{i - 1}",
        :content => "content_#{i - 1}",
        :created_at => today,
        :status => (i - 1) % Task::STATUS.keys.length,
        :expire_date => expire_date
      }
      @task = Task.new(params)
      @task.save
      today = today + 10
      expire_date = expire_date + 3
    end

    params = [
      {
        q: "name_0",
        expect: 1
      },
      {
        status: 1,
        expect: 3
      },
      {
        q: "not exist",
        expect: 0
      },
    ]

    visit root_path
    expect(page.all("tbody > tr").length).to eq 10

    params.each do |param|
      if param[:q].present?
        fill_in "q", with: param[:q]
      end
      if param[:status].present?
        select Task::STATUS.fetch(param[:status]), from: "status"
      end
      click_button "検索"
      expect(page.all("tbody > tr").length).to eq param[:expect]
      visit root_path
    end
  end
end

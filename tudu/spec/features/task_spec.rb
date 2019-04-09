require "rails_helper"

RSpec.feature "task management", :type => :feature do

  before do
    params = {
      :name => "dummy name",
      :content => "dummy content"
    }
    @task = Task.new(params)
    @task.save
  end

  scenario "End User Create a new task" do

    visit "/tasks/new"
    fill_in "task[name]", :with => "タスク名1"
    fill_in "task[content]", :with => "タスク内容1"
    click_button "登録"
    expect(page).to have_text("タスクを登録しました")
    
  end

  scenario "end user update a task" do

    visit "/tasks/#{@task.id}/edit"
    fill_in "task[name]", :with => "タスク名1 update"
    fill_in "task[content]", :with => "タスク内容1 update"
    click_button "変更を保存する"
    expect(page).to have_text("タスクを保存しました")

  end

  scenario "end user show a task" do

    visit "/tasks/#{@task.id}"
    expect(page).to have_text(@task.name)
    expect(page).to have_text(@task.content)

  end

  scenario "end user view task list and delete" do

    visit "/tasks/#{@task.id}"
    expect(page).to have_text(@task.name)
    expect(page).to have_text(@task.content)

    expect(page).to have_text("詳細")
    expect(page).to have_text("編集")
    expect(page).to have_text("削除")

    click_link "削除"
    expect(page).to have_text("タスクを削除しました")
    expect(page).not_to have_link("削除")

  end

end

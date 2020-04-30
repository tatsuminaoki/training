require 'rails_helper'
require 'capybara/rspec'

describe "task system", type: :feature do
  before :each do
    @task = Task.create!(title: 'hoge', memo: 'hugahuga')
  end
  
  it "index" do
    visit tasks_path
    
    expect(page).to have_content 'Task一覧'
    expect(page).to have_content 'Task名'
    expect(page).to have_content 'memo'
  end
  
  it "new" do
    visit new_task_path

    fill_in 'Title', with: 'huga'
    fill_in 'Memo', with: 'hogehoge'

    click_on 'Create Task'
    expect(page).to have_content 'Taskは正常に作成されました'
  end

  it "edit" do
    visit edit_task_path(@task)

    fill_in 'Title', with: 'test'
    fill_in 'Memo', with: 'testtest'

    click_on 'Update Task'
    expect(page).to have_content 'Taskは正常に更新されました'
  end
  
  it "show" do
    visit task_path(@task)

    expect(page).to have_content 'Task詳細'
    expect(page).to have_content 'hoge'
    expect(page).to have_content 'hugahuga'
  end

  it "delete" do
    visit task_path(@task)

    click_on 'Delete'
    expect(page).to have_content 'Taskは正常に削除されました'
  end
  
end

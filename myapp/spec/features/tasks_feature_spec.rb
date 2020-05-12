require 'rails_helper'
require 'capybara/rspec'

describe "task system", type: :feature do
  before(:each) do
    @task = create(:task)
    @task1 = create(:task1)
    @task2 = create(:task2)
    @task3 = create(:task3)
    @task4 = create(:task4)
  end
 
  context "index" do
    it 'screen' do
      visit tasks_path
    
      expect(page).to have_content 'Task一覧'
      expect(page).to have_content 'Title'
      expect(page).to have_content 'Memo'
    end

    it 'sort' do
      visit '/tasks?sort=created_at+desc'
      task_array = all('.task')
        expect(task_array[0]).to have_content @task4.title
        expect(task_array[1]).to have_content @task3.title
        expect(task_array[2]).to have_content @task2.title
        expect(task_array[3]).to have_content @task1.title
        expect(task_array[4]).to have_content @task.title
    end

  end
  
  it "new" do
    visit new_task_path

    fill_in 'Title', with: 'huga'
    fill_in 'Memo', with: 'hogehoge'

    click_button '登録する'
    expect(page).to have_content 'Taskは正常に作成されました'
  end

  it "edit" do
    visit edit_task_path(@task)

    fill_in 'Title', with: 'test'
    fill_in 'Memo', with: 'testtest'

    click_button '更新する'
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

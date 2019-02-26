require 'rails_helper'

RSpec.feature 'tasks', type: :feature do

  background do
    task = FactoryBot.create(:task)
  end

  scenario 'task list' do
    visit tasks_path

    expect(page).to have_content 'タスク一覧'
    expect(Task.count).to equal 1
  end

  scenario 'task list sort order' do
    2.times{
      sleep(1)
      task = FactoryBot.create(:task)
    }
    visit tasks_path
    task_titles = page.all('td.title')
    expect(task_titles[0]).to have_content 'test title 4'
    expect(task_titles[1]).to have_content 'test title 3'
    expect(task_titles[2]).to have_content 'test title 2'
  end

  scenario 'task new' do
    visit new_task_path

    fill_in 'タイトル', with: 'test Title'
    fill_in '説明', with: 'test Description'
    fill_in '登録者', with: '1'
    select '2024', from: 'task_limit_1i'
    select '1月', from: 'task_limit_2i'
    select '29', from: 'task_limit_3i'
    select '22', from: 'task_limit_4i'
    select '59', from: 'task_limit_5i'
    select '5', from: 'task_priority'
    select '完了', from: 'task_status'

    click_button '登録する'

    expect(page).to have_content 'タスクが保存されました'
  end

  scenario 'task add count' do
    visit new_task_path

    expect{
      fill_in 'タイトル', with: 'test Title'
      fill_in '説明', with: 'test Description'
      fill_in '登録者', with: '1'
      select '2024', from: 'task_limit_1i'
      select '1月', from: 'task_limit_2i'
      select '29', from: 'task_limit_3i'
      select '22', from: 'task_limit_4i'
      select '59', from: 'task_limit_5i'
      select '5', from: 'task_priority'
      select '完了', from: 'task_status'

      click_button '登録する'
    }.to change{Task.count}.by(1)
  end

  scenario 'task edit' do
    visit tasks_path
    click_link '修正'

    fill_in 'タイトル', with: 'new Title'
    fill_in '説明', with: 'new Description'

    click_button '更新する'

    expect(page).to have_content 'タスクが更新されました'
    expect(page).to have_content 'new Title'
  end  

  scenario 'task delete' do
    visit tasks_path
    click_link '削除'

    expect(page).to have_content 'タスクが削除されました'
  end

  scenario 'task delete count' do
    visit tasks_path
    expect{click_link '削除'}.to change{Task.count}.by(-1)
  end

  scenario 'click search without filling form' do
    visit tasks_path
    expect{click_button 'Search'}.to change{Task.count}.by(0)
  end

  scenario 'click search status' do
    create(:task, title: 'test title 2',status:2)
    create(:task, title: 'test title 2',status:2)

    visit tasks_path
    
    expect{
      select '完了', from: 'status'
      click_button 'Search'  
    }.to change{page.all('td.title').count}.to(2)
  end

  scenario 'search with status' do
    create(:task, title: 'test title 0',status:0)
    create(:task, title: 'test title 1',status:1)
    create(:task, title: 'test title 2',status:2)
    create(:task, title: 'test title 2',status:2)

    visit tasks_path

    expect{
      select '未着手', from: 'status'
      click_button 'Search'  
    }.to change{page.all('td.title').count}.to(1)

  end

  scenario 'search with title' do
    create(:task, title: 'test title 0',status:0)
    create(:task, title: 'test title 1',status:1)
    create(:task, title: 'test title 2',status:2)
    create(:task, title: 'test title 2',status:2)

    visit tasks_path
    
    expect{
      fill_in 'title', with: 'test title 2'
      click_button 'Search'  
    }.to change{page.all('td.title').count}.to(2)
  end

  scenario 'search with title and status' do
    create(:task, title: 'test title 0',status:0)
    create(:task, title: 'test title 1',status:1)
    create(:task, title: 'test title 2',status:2)
    create(:task, title: 'test title 3',status:2)

    visit tasks_path
    
    expect{
      fill_in 'title', with: 'test title 3'
      select '完了', from: 'status'
      click_button 'Search'  
    }.to change{page.all('td.title').count}.to(1)
  end

  scenario 'search with title and status:no result' do
    create(:task, title: 'test title 0',status:0)
    create(:task, title: 'test title 2',status:2)
    create(:task, title: 'test title 2',status:2)
    create(:task, title: 'test title 3',status:2)

    visit tasks_path
    
    expect{
      fill_in 'title', with: 'x'
      select '完了', from: 'status'
      click_button 'Search'  
    }.to change{page.all('td.title').count}.to(0)
  end
end
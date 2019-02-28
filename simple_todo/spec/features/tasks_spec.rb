require 'rails_helper'

RSpec.feature 'tasks', type: :feature do

  feature 'task list page' do
    background do
      create(:user)
      create(:task)
      visit tasks_path
    end

    scenario 'task list' do
      expect(page).to have_content 'タスク一覧'
      expect(Task.count).to equal 1
    end

    scenario 'task edit' do
      click_link '修正'
      fill_in 'タイトル', with: 'new Title'
      fill_in '説明', with: 'new Description'

      click_button '更新する'

      expect(page).to have_content 'タスクが更新されました'
      expect(page).to have_content 'new Title'
    end

    scenario 'task delete' do
      click_link '削除'
      expect(page).to have_content 'タスクが削除されました'
    end

    scenario 'task delete count' do
      expect{click_link '削除'}.to change{Task.count}.by(-1)
    end

    scenario 'task list sort order' do
      create(:task, title: 'test title 11', created_at: '2019-03-18 12:29:00')
      create(:task, title: 'test title 12', created_at: '2019-03-28 12:29:00')
      visit tasks_path

      task_titles = page.all('td.title')
      expect(task_titles[0]).to have_content 'test title 12'
      expect(task_titles[1]).to have_content 'test title 11'
    end
  end

  feature 'new task add page' do
    background do
      create(:user)
      visit new_task_path
    end

    scenario 'add task' do
      fill_in 'タイトル', with: 'test Title'
      fill_in '説明', with: 'test Description'
      fill_in '登録者', with: '1'
      select '2024', from: 'task_limit_1i'
      select '1月', from: 'task_limit_2i'
      select '29', from: 'task_limit_3i'
      select '22', from: 'task_limit_4i'
      select '59', from: 'task_limit_5i'
      select '5', from: 'task_priority'
      find("option[value='done']").select_option
      click_button '登録する'
      expect(page).to have_content 'タスクが保存されました'
    end

    scenario 'add task' do
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
        find("option[value='done']").select_option
        click_button '登録する'
      }.to change{Task.count}.by(1)
    end
  end

  feature 'search feature' do
    background do
      create(:user)
      create(:task, title: 'test title 0',status:0)
      create(:task, title: 'test title 1',status:1)
      create(:task, title: 'test title 2',status:2)
      create(:task, title: 'test title 3',status:2)
      visit tasks_path
    end

    scenario 'click search without filling form' do
      expect{click_button '検索'}.to change{Task.count}.by(0)
    end

    scenario 'click search status' do
      expect{
        find('#status').find("option[value='2']").select_option
        click_button '検索'
      }.to change{page.all('td.title').count}.to(2)
    end

    scenario 'search with status' do
      expect{
        find('#status').find("option[value='0']").select_option
        click_button '検索'
      }.to change{page.all('td.title').count}.to(1)
    end

    scenario 'search with title' do
      expect{
        fill_in 'title', with: 'test title 2'
        click_button '検索'
      }.to change{page.all('td.title').count}.to(1)
    end

    scenario 'search with title and status' do
      expect{
        fill_in 'title', with: 'test title 3'
        find('#status').find("option[value='2']").select_option
        click_button '検索'
      }.to change{page.all('td.title').count}.to(1)
    end

    scenario 'search with title and status:no result' do
      expect{
        fill_in 'title', with: 'x'
        find('#status').find("option[value='2']").select_option
        click_button '検索'
      }.to change{page.all('td.title').count}.to(0)
    end
  end

  feature 'pagenation' do
    background do
      create(:user)
      10.times{
        create(:task)
      }
      visit tasks_path
    end
    
    scenario 'displays 8 tasks in first page ' do
      expect(page.all('td.title').count).to eq(8)
    end

    scenario 'displays 2 tasks in next page ' do
      expect{
        click_link '次'
      }.to change{page.all('td.title').count}.to(2)
    end

    scenario 'displays 2 tasks in next page ' do
      expect{
        click_link '最後'
      }.to change{page.all('td.title').count}.to(2)
    end
  end

end
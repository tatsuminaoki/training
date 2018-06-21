require 'rails_helper'

RSpec.feature "Tasks", type: :feature do
  background do
    Capybara.default_host = 'http://localhost:3000'
    @task = create(:task)
  end

  context '正常パターンのテスト' do
    scenario '一覧画面からタスク登録画面に遷移' do
      visit root_path
      click_on I18n.t('button.new')

      expect(current_url).to eq 'http://localhost:3000/tasks/new'
      expect(page).to have_field 'task_task_name'
      expect(page).to have_field 'task_description'
      expect(page).to have_button I18n.t('helpers.submit.create')
    end
    
    scenario 'タスクの登録' do
      visit 'http://localhost:3000/tasks/new'
      fill_in 'task_task_name', with: "#{@task.task_name}"
      fill_in 'task_description', with: "#{@task.description}"
      click_button I18n.t('helpers.submit.create')
      
      expect(current_url).to eq 'http://localhost:3000/'
      expect(page).to have_content I18n.t('flash.success_create')
      expect(page).to have_content I18n.t('view.task_name', :task => @task.task_name)
    end
    
    scenario '一覧画面からタスク詳細画面への遷移' do
      visit root_path
      click_on I18n.t('view.task_name', :task => @task.task_name)
      
      expect(current_url).to eq "http://localhost:3000/tasks/show/#{@task.id}"
      expect(page).not_to have_content I18n.t('flash.success_update')
      expect(page).to have_content I18n.t('button.home')
      expect(page).to have_content I18n.t('button.edit')
      expect(page).to have_content I18n.t('button.delete')
      expect(page).to have_content I18n.t('view.task_name', :task => @task.task_name)
      expect(page).to have_content I18n.t('view.description', :task => @task.description)
    end

    scenario 'タスク詳細画面から一覧画面に遷移' do
      visit "http://localhost:3000/tasks/show/#{@task.id}"
      click_on I18n.t('button.home')

      expect(current_url).to eq 'http://localhost:3000/'
      expect(page).not_to have_content I18n.t('flash.success_create')
      expect(page).not_to have_content I18n.t('flash.success_delete', :task => @task.task_name)
      expect(page).to have_content I18n.t('button.new')
      expect(page).to have_content I18n.t('view.task_name', :task => @task.task_name)
    end

    scenario '一覧画面でタスクを作成日の降順に表示' do
      3.times do
        Timecop.travel(Time.now + 1.day)
        create(:task)
      end
      Timecop.return
      visit root_path

      tasks_list = all('ul li')
      tasks = Task.select('task_name').order('created_at DESC')
      task_names = []
      tasks.each do |t|
        task_names << 'タスク：' + t.task_name
      end
      tasks_list.each_with_index do |t, i|
        expect(t.text).to eq task_names[i]
      end
    end

    scenario 'タスク詳細画面からタスク編集画面に遷移' do
      visit "http://localhost:3000/tasks/show/#{@task.id}"
      click_on I18n.t('button.edit')  
      
      expect(current_url).to eq "http://localhost:3000/tasks/edit/#{@task.id}" 
      expect(page).to have_field 'task_task_name', with: @task.task_name
      expect(page).to have_field 'task_description', with: @task.description
      expect(page).to have_button I18n.t('helpers.submit.update')
    end

    scenario 'タスクの編集' do
      visit "http://localhost:3000/tasks/edit/#{@task.id}"
      fill_in 'task_task_name', with: "#{@task.task_name}(edited)"
      fill_in 'task_description', with: "#{@task.description}(edited)"
      click_button I18n.t('helpers.submit.update')

      expect(current_url).to eq "http://localhost:3000/tasks/show/#{@task.id}"
      expect(page).to have_content I18n.t('flash.success_update')
      expect(page).to have_content I18n.t('view.task_name', :task => @task.task_name)
      expect(page).to have_content I18n.t('view.description', :task => @task.description)
    end

    scenario 'タスクの削除' do
      visit "http://localhost:3000/tasks/show/#{@task.id}"
      click_on I18n.t('button.delete')
      
      expect(current_url).to eq 'http://localhost:3000/'
      expect(page).to have_content I18n.t('flash.success_delete', :task => @task.task_name)
      visit current_path
      expect(page).not_to have_content I18n.t('view.task_name', :task => @task.task_name)
    end
  end

  context '登録・更新の失敗' do
    scenario '0文字のタスクを登録' do
      visit 'http://localhost:3000/tasks/new'
      fill_in 'task_task_name', with: ''
      fill_in 'task_description', with: "#{@task.description}"
      click_button I18n.t('helpers.submit.create')
      
      expect(current_url).to eq 'http://localhost:3000/tasks/create'
      expect(page).to have_content 'タスク名を入力してください。'
    end
    
    scenario '256文字のタスクを登録' do
      visit 'http://localhost:3000/tasks/new'
      fill_in 'task_task_name', with: 'a'*256
      fill_in 'task_description', with: "#{@task.description}"
      click_button I18n.t('helpers.submit.create')
      
      expect(current_url).to eq 'http://localhost:3000/tasks/create'
      expect(page).to have_content 'タスク名は255字以内で入力してください。'
    end

    scenario '0文字のタスクに更新' do
      visit "http://localhost:3000/tasks/edit/#{@task.id}"
      fill_in 'task_task_name', with: ''
      fill_in 'task_description', with: "#{@task.description}(edited)"
      click_button I18n.t('helpers.submit.update')

      expect(current_url).to eq "http://localhost:3000/tasks/edit/#{@task.id}"
      expect(page).to have_content 'タスク名を入力してください。'
    end

    scenario '256文字のタスクに更新' do
      visit "http://localhost:3000/tasks/edit/#{@task.id}"
      fill_in 'task_task_name', with: 'a'*256
      fill_in 'task_description', with: "#{@task.description}(edited)"
      click_button I18n.t('helpers.submit.update')

      expect(current_url).to eq "http://localhost:3000/tasks/edit/#{@task.id}"
      expect(page).to have_content 'タスク名は255字以内で入力してください。'
    end
  end
end

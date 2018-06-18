require 'rails_helper'

RSpec.feature "Tasks", type: :feature do
  background do
    Capybara.default_host = 'http://localhost:3000'
    @task = create(:task)
  end

  scenario '一覧画面からタスク登録画面に遷移' do
    visit root_path
    click_button I18n.t('button.new')
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
    expect(page).to have_button I18n.t('button.home')
    expect(page).to have_button I18n.t('button.edit')
    expect(page).to have_button I18n.t('button.delete')
    expect(page).to have_content I18n.t('view.task_name', :task => @task.task_name)
    expect(page).to have_content I18n.t('view.description', :task => @task.description)
  end

  scenario 'タスク詳細画面から一覧画面に遷移' do
    visit "http://localhost:3000/tasks/show/#{@task.id}"
    click_button I18n.t('button.home')

    expect(current_url).to eq 'http://localhost:3000/'
    expect(page).not_to have_content I18n.t('flash.success_create')
    expect(page).not_to have_content I18n.t('flash.success_delete', :task => @task.task_name)
    expect(page).to have_button I18n.t('button.new')
    expect(page).to have_content I18n.t('view.task_name', :task => @task.task_name)
  end

  scenario 'タスク詳細画面からタスク編集画面に遷移' do
    visit "http://localhost:3000/tasks/show/#{@task.id}"
    click_button I18n.t('button.edit')
    
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
    click_button I18n.t('button.delete')
    
    expect(current_url).to eq 'http://localhost:3000/'
    expect(page).to have_content I18n.t('flash.success_delete', :task => @task.task_name)
    visit current_path
    expect(page).not_to have_content I18n.t('view.task_name', :task => @task.task_name)
  end
end

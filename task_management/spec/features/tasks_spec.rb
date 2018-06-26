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
      expect(page).to have_field 'task_due_date'
      expect(page).to have_button I18n.t('helpers.submit.create')
    end
    
    scenario 'タスクの登録' do
      visit 'http://localhost:3000/tasks/new'
      fill_in 'task_task_name', with: "#{@task.task_name}"
      fill_in 'task_description', with: "#{@task.description}"
      fill_in 'task_due_date', with: "#{@task.due_date}"
      click_button I18n.t('helpers.submit.create')
      
      expect(current_url).to eq 'http://localhost:3000/'
      expect(page).to have_content I18n.t('flash.success_create')
      expect(page).to have_content I18n.t('view.task_name', :task => @task.task_name)
      expect(page).to have_content I18n.t('view.due_date', :task => @task.due_date)
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
      expect(page).to have_content I18n.t('view.due_date', :task => @task.due_date)
    end

    scenario 'タスク詳細画面から一覧画面に遷移' do
      visit "http://localhost:3000/tasks/show/#{@task.id}"
      click_on I18n.t('button.home')

      expect(current_url).to eq 'http://localhost:3000/'
      expect(page).not_to have_content I18n.t('flash.success_create')
      expect(page).not_to have_content I18n.t('flash.success_delete', :task => @task.task_name)
      expect(page).to have_content I18n.t('button.new')
      expect(page).to have_content I18n.t('sort.due_date.desc')
      expect(page).to have_content I18n.t('view.task_name', :task => @task.task_name)
      expect(page).to have_content I18n.t('view.due_date', :task => @task.due_date)
    end

    scenario '一覧画面でタスクを作成日の降順に表示' do
      3.times do
        Timecop.travel(Time.now + 1.day)
        create(:task)
      end
      Timecop.return
      visit root_path

      tasks_list = all('ul li')
      tasks_desc = Task.select('task_name', 'due_date').order('created_at DESC')
      tasks = []
      tasks_desc.each do |t|
        tasks << 'タスク：' + t.task_name
        tasks << '期限：' + t.due_date.to_s
      end
      tasks_list.each_with_index do |t, i|
        expect(t.text).to eq tasks[i]
      end
      expect(page).to have_content I18n.t('sort.due_date.desc')
    end

    scenario '一覧画面でタスクを期限の昇順に表示' do
      3.times do
        create(:task)
      end
      visit root_path(@tasks, sort: 'due_date_desc')
      click_on I18n.t('sort.due_date.asc')

      tasks_list = all('ul li')
      tasks_asc = Task.select('task_name', 'due_date').order('due_date ASC')
      tasks = []
      tasks_asc.each do |t|
        tasks << 'タスク：' + t.task_name
        tasks << '期限：' + t.due_date.to_s
      end
      tasks_list.each_with_index do |t, i|
        expect(t.text).to eq tasks[i]
      end
      expect(current_url).to eq 'http://localhost:3000/?sort=due_date_asc'
      expect(page).to have_content I18n.t('sort.due_date.desc')
    end

    scenario '一覧画面でタスクを期限の降順に表示' do
      3.times do
        create(:task)
      end
      visit root_path(@tasks, sort: 'due_date_asc')
      click_on I18n.t('sort.due_date.desc')

      tasks_list = all('ul li')
      tasks_desc = Task.select('task_name', 'due_date').order('due_date DESC')
      tasks = []
      tasks_desc.each do |t|
        tasks << 'タスク：' + t.task_name
        tasks << '期限：' + t.due_date.to_s
      end
      tasks_list.each_with_index do |t, i|
        expect(t.text).to eq tasks[i]
      end
      expect(current_url).to eq 'http://localhost:3000/?sort=due_date_desc'
      expect(page).to have_content I18n.t('sort.due_date.asc')
    end
    
    scenario 'タスク詳細画面からタスク編集画面に遷移' do
      visit "http://localhost:3000/tasks/show/#{@task.id}"
      click_on I18n.t('button.edit')
      
      expect(current_url).to eq "http://localhost:3000/tasks/edit/#{@task.id}"
      expect(page).to have_field 'task_task_name', with: @task.task_name
      expect(page).to have_field 'task_description', with: @task.description
      expect(page).to have_field 'task_due_date', with: @task.due_date
      expect(page).to have_button I18n.t('helpers.submit.update')
    end

    scenario 'タスクの編集' do
      visit "http://localhost:3000/tasks/edit/#{@task.id}"
      fill_in 'task_task_name', with: "#{@task.task_name}(edited)"
      fill_in 'task_description', with: "#{@task.description}(edited)"
      fill_in 'task_due_date', with: "#{(@task.due_date + 1).to_s}"
      click_button I18n.t('helpers.submit.update')

      expect(current_url).to eq "http://localhost:3000/tasks/show/#{@task.id}"
      expect(page).to have_content I18n.t('flash.success_update')
      expect(page).to have_content I18n.t('view.task_name', :task => @task.task_name + '(edited)')
      expect(page).to have_content I18n.t('view.description', :task => @task.description + '(edited)')
      expect(page).to have_content I18n.t('view.due_date', :task => (@task.due_date + 1).to_s)
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
      fill_in 'task_due_date', with: "#{@task.due_date}"
      click_button I18n.t('helpers.submit.create')
      
      expect(current_url).to eq 'http://localhost:3000/tasks/create'
      expect(page).to have_content 'タスク名を入力してください。'
    end
    
    scenario '256文字のタスクを登録' do
      visit 'http://localhost:3000/tasks/new'
      fill_in 'task_task_name', with: 'a'*256
      fill_in 'task_description', with: "#{@task.description}"
      fill_in 'task_due_date', with: "#{@task.due_date}"
      click_button I18n.t('helpers.submit.create')
      
      expect(current_url).to eq 'http://localhost:3000/tasks/create'
      expect(page).to have_content 'タスク名は255字以内で入力してください。'
    end

    scenario '存在しない日付を登録' do
      visit 'http://localhost:3000/tasks/new'
      fill_in 'task_task_name', with: "#{@task.task_name}"
      fill_in 'task_description', with: "#{@task.description}"
      fill_in 'task_due_date', with: '2018-06-31'
      click_button I18n.t('helpers.submit.create')
      
      expect(current_url).to eq 'http://localhost:3000/tasks/create'
      expect(page).to have_content '期限を正しく入力してください。'
    end

    scenario 'タスク名が0文字かつ存在しない日付を登録' do
      visit 'http://localhost:3000/tasks/new'
      fill_in 'task_task_name', with: ''
      fill_in 'task_description', with: "#{@task.description}"
      fill_in 'task_due_date', with: '2018-06-31'
      click_button I18n.t('helpers.submit.create')
      
      expect(current_url).to eq 'http://localhost:3000/tasks/create'
      expect(page).to have_content 'タスク名を入力してください。' 
      expect(page).to have_content '期限を正しく入力してください。'
    end

    scenario '0文字のタスクに更新' do
      visit "http://localhost:3000/tasks/edit/#{@task.id}"
      fill_in 'task_task_name', with: ''
      fill_in 'task_description', with: "#{@task.description}(edited)"
      fill_in 'task_due_date', with: "#{(@task.due_date + 1).to_s}"
      click_button I18n.t('helpers.submit.update')

      expect(current_url).to eq "http://localhost:3000/tasks/edit/#{@task.id}"
      expect(page).to have_content 'タスク名を入力してください。'
    end

    scenario '256文字のタスクに更新' do
      visit "http://localhost:3000/tasks/edit/#{@task.id}"
      fill_in 'task_task_name', with: 'a'*256
      fill_in 'task_description', with: "#{@task.description}(edited)"
      fill_in 'task_due_date', with: "#{(@task.due_date + 1).to_s}"
      click_button I18n.t('helpers.submit.update')

      expect(current_url).to eq "http://localhost:3000/tasks/edit/#{@task.id}"
      expect(page).to have_content 'タスク名は255字以内で入力してください。'
    end

    scenario '存在しない日付に更新' do
      visit "http://localhost:3000/tasks/edit/#{@task.id}"
      fill_in 'task_task_name', with: "#{@task.task_name}(edited)"
      fill_in 'task_description', with: "#{@task.description}(edited)"
      fill_in 'task_due_date', with: '2018-06-31'
      click_button I18n.t('helpers.submit.update')

      expect(current_url).to eq "http://localhost:3000/tasks/edit/#{@task.id}"
      expect(page).to have_content '期限を正しく入力してください。'
    end

    scenario 'タスク名が256文字かつ存在しない日付に更新' do
      visit "http://localhost:3000/tasks/edit/#{@task.id}"
      fill_in 'task_task_name', with: 'a'*256
      fill_in 'task_description', with: "#{@task.description}(edited)"
      fill_in 'task_due_date', with: '2018-06-31'
      click_button I18n.t('helpers.submit.update')

      expect(current_url).to eq "http://localhost:3000/tasks/edit/#{@task.id}"
      expect(page).to have_content 'タスク名は255字以内で入力してください。' 
      expect(page).to have_content '期限を正しく入力してください。'
    end
  end
end

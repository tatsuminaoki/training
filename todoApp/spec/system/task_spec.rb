require 'rails_helper'

RSpec.describe 'Task management', type: :system, js: true do
  context 'visit the tasks_path' do
    before do
      user1 = User.create!(name: 'John', email: 'test@example.com', password: 'mypassword')
      Task.create!(title: 'rspec first task', description: 'first description', user_id: user1.id)
      Task.create!(title: 'rspec second task', description: 'second description', user_id: user1.id)

      visit login_path
      fill_in 'Email', with: :'test@example.com'
      fill_in 'Password', with: :'mypassword'
      click_button 'Log In'
    end

    it 'shows the task list order by created recently.' do
      visit tasks_path
      recent_title = find(:xpath, ".//table/tbody/tr[1]/td[1]").text
      old_title = find(:xpath, ".//table/tbody/tr[2]/td[1]").text
      expect(recent_title).to have_content 'rspec second task'
      expect(old_title).to have_content 'rspec first task'
    end
  end

  context 'user click the link' do
    before do
      user1 = User.create!(name: 'John', email: 'test@example.com', password: 'mypassword')
      Task.create!(title: 'rspec first task', description: 'rspec Description', user_id: user1.id)

      visit login_path
      fill_in 'Email', with: :'test@example.com'
      fill_in 'Password', with: :'mypassword'
      click_button 'Log In'
    end

    it 'creates new task when click New Task' do
      visit tasks_path
      click_link 'New Task'
      fill_in 'Title', :with => 'My Task'
      fill_in 'Description', :with => 'My Task Description'
      click_button 'Create Task'
      expect(page).to have_content 'Task was successfully created.'
    end

    it 'ensures Title presence when creates new task.' do
      visit tasks_path
      click_link 'New Task'
      fill_in 'Description', :with => 'My Task Description'
      click_button 'Create Task'
      expect(page).to have_content "Title can't be blank"
    end

    it 'ensures Title length must be less than 50 when creates new task' do
      visit tasks_path
      click_link 'New Task'
      fill_in 'Title', :with => 'a' * 51
      fill_in 'Description', :with => 'My Task Description'
      click_button 'Create Task'
      expect(page).to have_content 'Title is too long (maximum is 50 characters)'
    end

    it 'updates the selected task when click Edit' do
      visit tasks_path
      click_link 'Edit'
      fill_in 'Title', :with => 'My Edited Task'
      fill_in 'Description', :with => 'Edit My Task Description'
      click_button 'Update Task'
      expect(page).to have_content 'Task was successfully updated.'
    end

    it 'ensures Title presence when updates task.' do
      visit tasks_path
      click_link 'Edit'
      fill_in 'Title', :with => ''
      fill_in 'Description', :with => 'Edit My Task Description'
      click_button 'Update Task'
      expect(page).to have_content "Title can't be blank"
    end

    it 'ensures Title length must be less than 50 when updates task.' do
      visit tasks_path
      click_link 'Edit'
      fill_in 'Title', :with => 'a' * 51
      fill_in 'Description', :with => 'Edit My Task Description'
      click_button 'Update Task'
      expect(page).to have_content 'Title is too long (maximum is 50 characters)'
    end

    it 'deletes the selected task when click Destroy' do
      visit tasks_path
      accept_alert do
        click_link 'Destroy'
      end
      expect(page).to have_content 'Task was successfully destroyed.'
    end
  end

  context 'when user search' do
    before do
      user1 = User.create!(name: 'John', email: 'test@example.com', password: 'mypassword')
      Task.create!(title: 'first task', description: 'deadline is soon', status: 'todo', due_date: 1.day.from_now, user_id: user1.id)
      Task.create!(title: 'second task', description: 'still have time until deadline', status: 'ongoing', due_date: 3.days.from_now, user_id: user1.id)

      visit login_path
      fill_in 'Email', with: :'test@example.com'
      fill_in 'Password', with: :'mypassword'
      click_button 'Log In'
    end

    it 'should be ascending order by due date when user search by due_date asc' do
      visit tasks_path
      select('ASC', from: 'Due Date')
      click_button 'Search'
      expect(page).to have_content 'Due Date'
      urgent_deadline = find(:xpath, ".//table/tbody/tr[1]/td[2]").text
      still_have_time = find(:xpath, ".//table/tbody/tr[2]/td[2]").text
      expect(urgent_deadline).to have_content 'deadline is soon'
      expect(still_have_time).to have_content 'still have time until deadline'
    end

    it 'should be descending order by due date when user search by due_date desc' do
      visit tasks_path
      select('DESC', from: 'Due Date')
      click_button 'Search'
      expect(page).to have_content 'Due Date'
      still_have_time = find(:xpath, ".//table/tbody/tr[1]/td[2]").text
      urgent_deadline = find(:xpath, ".//table/tbody/tr[2]/td[2]").text
      expect(still_have_time).to have_content 'still have time until deadline'
      expect(urgent_deadline).to have_content 'deadline is soon'
    end

    it 'only shows searched task list when user search by title' do
      visit tasks_path
      fill_in 'Title Keyword', :with => 'first task'
      click_button 'Search'
      expect(page).to have_no_content 'second task'
    end

    it 'only shows searched task list when user search by status' do
      visit tasks_path
      select('todo', from: 'Current Status')
      click_button 'Search'
      within_table('task table') do
        expect(page).to have_no_content 'ongoing'
      end
    end
  end

  context 'When user paginate' do
    before do
      user1 = User.create!(name: 'John', email: 'test@example.com', password: 'mypassword')
      1.upto(8){ |k| Task.create!(title: "Title #{k}", user_id: user1.id) }

      visit login_path
      fill_in 'Email', with: :'test@example.com'
      fill_in 'Password', with: :'mypassword'
      click_button 'Log In'
    end

    it 'shows paginate links if more than one page' do
      visit tasks_path
      expect(page).to have_selector 'nav.pagination'
    end

    it "ensures paginate working properly" do
      visit tasks_path
      click_link 'Last »'
      expect(page).to have_link '« First'
    end
  end

  context 'when user access tasks page without login' do
    it "should be redirected to login page" do
      visit tasks_path
      expect(page).to have_current_path '/en/login'
    end
  end

  context 'visit the tasks_path' do
    before do
      user1 = User.create!(name: 'John', email: 'user1@example.com', password: 'u1password')
      user2 = User.create!(name: 'Mary', email: 'user2@example.com', password: 'u2password')
      Task.create!(title: 'user1 task', user_id: user1.id)
      Task.create!(title: 'user2 task', user_id: user2.id)

      visit login_path
      fill_in 'Email', with: :'test@example.com'
      fill_in 'Password', with: :'mypassword'
      click_button 'Log In'
    end

    it "shows only logged in user's tasks" do
      visit login_path
      fill_in 'Email', with: :'user1@example.com'
      fill_in 'Password', with: :'u1password'
      click_button 'Log In'
      expect(page).to have_current_path '/en/tasks'
      expect(page).to have_no_content 'user2 task'
    end
  end
end

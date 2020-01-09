require 'rails_helper'

RSpec.describe 'Task management', type: :system, js: true do
  context 'visit the tasks_path' do
    before do
      Task.create!(title: 'rspec first task', description: 'deadline is soon', due_date: 1.day.from_now)
      Task.create!(title: 'rspec second task', description: 'still have time until deadline', due_date: 3.days.from_now)
    end

    it 'shows the task list order by created recently.' do
      visit tasks_path
      recent_title = find(:xpath, ".//table/tbody/tr[1]/td[1]").text
      old_title = find(:xpath, ".//table/tbody/tr[2]/td[1]").text
      expect(recent_title).to have_content 'rspec second task'
      expect(old_title).to have_content 'rspec first task'
    end

    it 'should be ascending order by due date when user click on ▲ symbol' do
      visit tasks_path
      click_link '▲'
      expect(page).to have_content 'Due Date'
      urgent_deadline = find(:xpath, ".//table/tbody/tr[1]/td[2]").text
      still_have_time = find(:xpath, ".//table/tbody/tr[2]/td[2]").text
      expect(urgent_deadline).to have_content 'deadline is soon'
      expect(still_have_time).to have_content 'still have time until deadline'
    end

    it 'should be descending order by due date when user click on ▼ symbol' do
      visit tasks_path
      click_link '▼'
      expect(page).to have_content 'Due Date'
      still_have_time = find(:xpath, ".//table/tbody/tr[1]/td[2]").text
      urgent_deadline = find(:xpath, ".//table/tbody/tr[2]/td[2]").text
      expect(still_have_time).to have_content 'still have time until deadline'
      expect(urgent_deadline).to have_content 'deadline is soon'
    end
  end

  context 'user click the link' do
    before do
      Task.create!(title: 'rspec first task', description: 'rspec Description')
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
end

require 'rails_helper'

RSpec.describe 'Tasks', type: :system, js: true  do

  let!(:test_task1) { Task.create( summary: 'task1', description: 'this is 1st task', priority: 1, status: 1 ) }
  let!(:test_task2) { Task.create( summary: 'task2', description: 'this is 2nd task', priority: 3, status: 3 ) }
  let!(:test_task3) { Task.create( summary: 'task3', description: 'this is 3rd task', priority: 5, status: 5 ) }

  describe 'Task List Page' do
    it 'Tests of Layout' do
      visit root_path
      expect(page).to have_content 'Task List'
      expect(page).to have_content 'task1'
      expect(page).to have_content 'this is 1st task'
      expect(page).to have_content 'highest'
      expect(page).to have_content 'open'
      expect(page).to have_content 'task2'
      expect(page).to have_content 'this is 2nd task'
      expect(page).to have_content 'middle'
      expect(page).to have_content 'review'
      expect(page).to have_content 'task3'
      expect(page).to have_content 'this is 3rd task'
      expect(page).to have_content 'lowest'
      expect(page).to have_content 'done'

      expect(Task.count).to eq 3
    end

    it 'Tests of Click Draft Anchor Link' do
      visit root_path
      click_on 'Draft'
      expect(current_path).to eq new_task_path
      expect(page).to have_content 'New Task'
      expect(find_field('Summary').value).to be_empty
      expect(find_field('Description').value).to be_empty
      expect(find_field('Priority').value).to eq 'middle'
      expect(page).to have_select('Status', selected: 'pelase select status')
      expect(find_field('Due').value).to be_empty
    end

    it 'Test of Click Detail Anchor Link' do
      visit root_path
      all('tbody tr')[0].click_link 'Detail'
      expect(current_path).to eq task_path(test_task1)
      expect(page).to have_content 'Task Detail'
      expect(page).to have_content 'task1'
      expect(page).to have_content 'this is 1st task'
      expect(page).to have_content 'highest'
      expect(page).to have_content 'open'
    end

    it 'Test of Click Edit Anchor Link' do
      visit root_path
      all('tbody tr')[0].click_link 'Edit'
      expect(current_path).to eq edit_task_path(test_task1)
      expect(page).to have_content 'Edit Task'
      expect(page).to have_content 'task1'
      expect(page).to have_content 'this is 1st task'
      expect(page).to have_content 'highest'
      expect(page).to have_content 'open'
    end
  end

  describe 'Task Registration Page' do
    let(:regist_task) { Task.new( summary: 'task4', description: 'this is 4th task', priority: 2, status: 2 ) }

    it 'displays default settings' do
      visit new_task_path
      expect(page).to have_content 'New Task'
      expect(find_field('Summary').value).to be_empty
      expect(find_field('Description').value).to be_empty
      expect(find_field('Priority').value).to eq 'middle'
      expect(page).to have_select('Status', selected: 'pelase select status')
      expect(find_field('Due').value).to be_empty
    end

    it 'is clicked Submit Button if set up normaly' do
      visit new_task_path
      expect {
        fill_in 'Summary', with: regist_task.summary
        fill_in 'Description', with: regist_task.description
        within find_field('Priority') do
          find("option[value='#{regist_task.priority}']").select_option
        end
        within find_field('Status') do
          find("option[value='#{regist_task.status}']").select_option
        end
        click_on 'Create Task'
      }.to change { Task.count }.by(1)
      expect(current_path).to eq task_path(Task.maximum(:id))
      expect(page).to have_content 'Task Detail'
      expect(page).to have_content 'task4'
      expect(page).to have_content 'this is 4th task'
    end

    it 'Test of Click Back Anchor Link' do
      visit new_task_path
      click_on 'Back'
      expect(current_path).to eq root_path
      expect(page).to have_content 'Task List'
    end
  end

  describe 'Task Editional Page' do
    let!(:edit_task) { Task.create( summary: 'task5', description: 'this is 5th task', priority: 4, status: 4 ) }
    let!(:del_task)  { Task.create( summary: 'task6', description: 'this is 6th task', priority: 2, status: 5 ) }

    it 'displays edit_task settings' do
      visit edit_task_path(edit_task)
      expect(page).to have_content 'Edit Task'
      expect(page).to have_content 'task5_edited'
      expect(page).to have_content 'this is 5th task_edited'
      expect(find_field('Priority').value).to eq 'lower'
      expect(page).to have_select('Status', selected: 're:open')
      expect(find_field('Due').value).to be_empty
    end

    it 'is clicked Submit Button if set up normaly' do
      visit edit_task_path(edit_task)
      expect {
        fill_in 'Summary', with: edit_task.summary + '_edited'
        fill_in 'Description', with: edit_task.description + '_edited'
        click_on 'Update Task'
      }.to change { Task.count }.by(0)
      expect(current_path).to eq task_path(edit_task)
      expect(page).to have_content 'Task Detail'
      expect(page).to have_content 'task5_edited'
      expect(page).to have_content 'this is 5th task_edited'
    end

    it 'is clicked Back Anchor Link' do
      visit edit_task_path(Task.maximum(:id))
      click_on 'Back'
      expect(current_path).to eq root_path
      expect(page).to have_content 'Task List'
    end

    it 'is clicked Delete Anchor Link and Cancel' do
      visit edit_task_path(del_task)
      expect {
        click_on 'Delete'
        expect(page.driver.browser.switch_to.alert.text).to eq 'Are you sure you want to delete this task?'
        page.driver.browser.switch_to.alert.dismiss
        expect(page).to have_content 'Edit Task'
      }.to change { Task.count }.by (0)
      expect(current_path).to eq edit_task_path(del_task)
      expect(find_field('Summary').value).to eq 'task6'
      expect(find_field('Description').value).to eq 'this is 6th task'
    end

    it 'is clicked Delete Anchor Link and OK' do
      visit edit_task_path(del_task)
      expect {
        click_on 'Delete'
        expect(page.driver.browser.switch_to.alert.text).to eq 'Are you sure you want to delete this task?'
        page.driver.browser.switch_to.alert.accept
        expect(page).to have_content 'Task List'
      }.to change { Task.count }.by (-1)
      expect(current_path).to eq tasks_path # root_path
      expect(page).to have_no_content 'task6'
      expect(page).to have_no_content 'this is 6th task'
    end
  end

  describe 'Task Detail Page' do
    it 'displays test_task1 settings' do
      visit task_path(test_task1)
      expect(page).to have_content 'Task Detail'
      expect(page).to have_content 'task1'
      expect(page).to have_content 'this is 1st task'
      expect(page).to have_content 'highest'
      expect(page).to have_content 'open'
    end

    it 'is increase when click Edit anchor-link' do
      visit task_path(test_task1)
      click_on 'Edit'
      expect(current_path).to eq edit_task_path(test_task1)
      expect(page).to have_content 'Edit Task'
      expect(page).to have_content 'task1'
      expect(page).to have_content 'this is 1st task'
      expect(page).to have_content 'highest'
      expect(page).to have_content 'open'
    end

    it 'Test of Click Back Anchor Link' do
      visit task_path(test_task1)
      click_on 'Back'
      expect(current_path).to eq root_path
      expect(page).to have_content 'Task List'
    end

    it 'is clicked Delete Anchor Link and Cancel' do
      visit task_path(test_task1)
      expect {
        click_on 'Delete'
        expect(page.driver.browser.switch_to.alert.text).to eq 'Are you sure you want to delete this task?'
        page.driver.browser.switch_to.alert.dismiss
        expect(page).to have_content 'Task Detail'
      }.to change { Task.count }.by (0)
      expect(current_path).to eq task_path(test_task1)
      expect(page).to have_content 'task1'
      expect(page).to have_content 'this is 1st task'
    end

    it 'is clicked Delete Anchor Link and OK' do
      visit task_path(test_task1)
      expect {
        click_on 'Delete'
        expect(page.driver.browser.switch_to.alert.text).to eq 'Are you sure you want to delete this task?'
        page.driver.browser.switch_to.alert.accept
        expect(page).to have_content 'Task List'
      }.to change { Task.count }.by (-1)
      expect(current_path).to eq tasks_path # root_pathに変更予定
      expect(page).to have_no_content 'task1'
      expect(page).to have_no_content 'this is 1st task'
    end
  end
end

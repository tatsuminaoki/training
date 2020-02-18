require 'rails_helper'

RSpec.describe 'Tasks', type: :system, js: true  do

  let!(:test_task1) { Task.create( summary: 'task1', description: 'this is 1st task', priority: 1, status: 1 ) }
  let!(:test_task2) { Task.create( summary: 'task2', description: 'this is 2nd task', priority: 3, status: 3 ) }
  let!(:test_task3) { Task.create( summary: 'task3', description: 'this is 3rd task', priority: 5, status: 5 ) }

  describe 'Task List Page' do
    it 'Tests of Layout' do
      visit root_path
      expect(page).to have_content I18n.t('tasks.index.title')
      expect(all('thead tr')[0].text).to have_content Task.human_attribute_name(:summary)
      expect(all('thead tr')[0].text).to have_content Task.human_attribute_name(:description)
      expect(all('thead tr')[0].text).to have_content Task.human_attribute_name(:priority)
      expect(all('thead tr')[0].text).to have_content Task.human_attribute_name(:status)
      expect(all('thead tr')[0].text).to have_content Task.human_attribute_name(:due)
      expect(all('thead tr')[0].text).to have_content Task.human_attribute_name(:created_at)
      expect(all('thead tr')[0].text).to have_no_content Task.human_attribute_name(:updated_at)
      expect(page).to have_content 'task1'
      expect(page).to have_content 'this is 1st task'
      expect(page).to have_content I18n.t('tasks.index.priority.highest')
      expect(page).to have_content I18n.t('tasks.index.status.open')
      expect(page).to have_content 'task2'
      expect(page).to have_content 'this is 2nd task'
      expect(page).to have_content I18n.t('tasks.index.priority.middle')
      expect(page).to have_content I18n.t('tasks.index.status.review')
      expect(page).to have_content 'task3'
      expect(page).to have_content 'this is 3rd task'
      expect(page).to have_content I18n.t('tasks.index.priority.lowest')
      expect(page).to have_content I18n.t('tasks.index.status.done')

      expect(Task.count).to eq 3
    end

    it 'record is sorted by created_at with desc order' do
      visit root_path
      expect(all('tbody tr')[0].text).to have_content test_task3.summary
      expect(all('tbody tr')[1].text).to have_content test_task2.summary
      expect(all('tbody tr')[2].text).to have_content test_task1.summary
    end 

    it 'Tests of Click Draft Anchor Link' do
      visit root_path
      click_on I18n.t('action.create')
      expect(current_path).to eq new_task_path
      expect(page).to have_content I18n.t('tasks.new.title')
      expect(find_field(Task.human_attribute_name(:summary)).value).to be_empty
      expect(find_field(Task.human_attribute_name(:description)).value).to be_empty
      expect(page).to have_select(Task.human_attribute_name(:priority), selected: I18n.t('tasks.index.priority.middle'))
      expect(page).to have_select(Task.human_attribute_name(:status), selected: I18n.t('flash.selector', item: Task.human_attribute_name(:status)))
      expect(find_field(Task.human_attribute_name(:due)).value).to be_empty
    end

    it 'Test of Click Detail Anchor Link' do
      visit root_path
      click_link I18n.t('action.detail'), match: :first
      expect(current_path).to eq task_path(test_task3)
      expect(page).to have_content I18n.t('tasks.show.title', task_id: test_task3.id)
      expect(page).to have_content 'task3'
      expect(page).to have_content 'this is 3rd task'
      expect(page).to have_content I18n.t('tasks.index.priority.lowest')
      expect(page).to have_content I18n.t('tasks.index.status.done')
    end

    it 'Test of Click Edit Anchor Link' do
      visit root_path
      click_link I18n.t('action.update'), match: :first
      expect(current_path).to eq edit_task_path(test_task3)
      expect(page).to have_content I18n.t('tasks.edit.title', task_id: test_task3.id)
      expect(find_field(Task.human_attribute_name(:summary)).value).to eq 'task3'
      expect(find_field(Task.human_attribute_name(:description)).value).to eq 'this is 3rd task'
      expect(page).to have_select(Task.human_attribute_name(:priority), selected: I18n.t('tasks.index.priority.lowest'))
      expect(page).to have_select(Task.human_attribute_name(:status), selected: I18n.t('tasks.index.status.done'))
    end
  end

  describe 'Task Registration Page' do
    let(:regist_task) { Task.new( summary: 'task4', description: 'this is 4th task', priority: 2, status: 2 ) }

    it 'displays default settings' do
      visit new_task_path
      expect(page).to have_content I18n.t('tasks.new.title')
      expect(find_field(Task.human_attribute_name(:summary)).value).to be_empty
      expect(find_field(Task.human_attribute_name(:description)).value).to be_empty
      expect(page).to have_select(Task.human_attribute_name(:priority), selected: I18n.t('tasks.index.priority.middle'))
      expect(page).to have_select(Task.human_attribute_name(:status), selected: I18n.t('flash.selector', item: Task.human_attribute_name(:status)))
      expect(find_field(Task.human_attribute_name(:due)).value).to be_empty
    end

    it 'is clicked Submit Button if set up normaly' do
      visit new_task_path
      expect {
        fill_in Task.human_attribute_name(:summary), with: regist_task.summary
        fill_in Task.human_attribute_name(:description), with: regist_task.description
        within find_field(Task.human_attribute_name(:priority)) do
          find("option[value='#{regist_task.priority}']").select_option
        end
        within find_field(Task.human_attribute_name(:status)) do
          find("option[value='#{regist_task.status}']").select_option
        end
        click_on I18n.t('action.create')
      }.to change { Task.count }.by(1)
      expect(current_path).to eq task_path(Task.maximum(:id))
      expect(page).to have_content I18n.t('tasks.show.title', task_id: Task.maximum(:id))
      expect(page).to have_content 'task4'
      expect(page).to have_content 'this is 4th task'
    end

    it 'Test of Click Back Anchor Link' do
      visit new_task_path
      click_on I18n.t('action.back')
      expect(current_path).to eq root_path
      expect(page).to have_content I18n.t('tasks.index.title')
    end
  end

  describe 'Task Editional Page' do
    let!(:edit_task) { Task.create( summary: 'task5', description: 'this is 5th task', priority: 4, status: 4 ) }
    let!(:del_task)  { Task.create( summary: 'task6', description: 'this is 6th task', priority: 2, status: 5 ) }

    it 'displays edit_task settings' do
      visit edit_task_path(edit_task)
      expect(page).to have_content I18n.t('tasks.edit.title', task_id: edit_task.id)
      expect(find_field(Task.human_attribute_name(:summary)).value).to eq 'task5'
      expect(find_field(Task.human_attribute_name(:description)).value).to eq 'this is 5th task'
      expect(page).to have_select(Task.human_attribute_name(:priority), selected: I18n.t('tasks.index.priority.lower'))
      expect(page).to have_select(Task.human_attribute_name(:status), selected: I18n.t('tasks.index.status.reopen'))
      expect(find_field(Task.human_attribute_name(:due)).value).to be_empty
    end

    it 'is clicked Submit Button if set up normaly' do
      visit edit_task_path(edit_task)
      expect {
        fill_in Task.human_attribute_name(:summary), with: edit_task.summary + '_edited'
        fill_in Task.human_attribute_name(:description), with: edit_task.description + '_edited'
        click_on I18n.t('action.update')
      }.to change { Task.count }.by(0)
      expect(current_path).to eq task_path(edit_task)
      expect(page).to have_content I18n.t('tasks.show.title', task_id: edit_task.id)
      expect(page).to have_content 'task5_edited'
      expect(page).to have_content 'this is 5th task_edited'
    end

    it 'is clicked Back Anchor Link' do
      visit edit_task_path(Task.maximum(:id))
      click_on I18n.t('action.back')
      expect(current_path).to eq root_path
      expect(page).to have_content I18n.t('tasks.index.title')
    end

    it 'is clicked Delete Anchor Link and Cancel' do
      visit edit_task_path(del_task)
      expect {
        click_on I18n.t('action.remove')
        expect(page.driver.browser.switch_to.alert.text).to eq I18n.t('flash.remove.confirm')
        page.driver.browser.switch_to.alert.dismiss
        expect(page).to have_content I18n.t('tasks.edit.title', task_id: del_task.id )
      }.to change { Task.count }.by (0)
      expect(current_path).to eq edit_task_path(del_task)
      expect(find_field(Task.human_attribute_name(:summary)).value).to eq 'task6'
      expect(find_field(Task.human_attribute_name(:description)).value).to eq 'this is 6th task'
    end

    it 'is clicked Delete Anchor Link and OK' do
      visit edit_task_path(del_task)
      expect {
        click_on I18n.t('action.remove')
        expect(page.driver.browser.switch_to.alert.text).to eq I18n.t('flash.remove.confirm')
        page.driver.browser.switch_to.alert.accept
        expect(page).to have_content I18n.t('tasks.index.title')
      }.to change { Task.count }.by (-1)
      expect(current_path).to eq tasks_path # root_path
      expect(page).to have_no_content 'task6'
      expect(page).to have_no_content 'this is 6th task'
    end
  end

  describe 'Task Detail Page' do
    it 'displays test_task1 settings' do
      visit task_path(test_task1)
      expect(page).to have_content I18n.t('tasks.show.title', task_id: test_task1.id)
      expect(page).to have_content 'task1'
      expect(page).to have_content 'this is 1st task'
      expect(page).to have_content I18n.t('tasks.index.priority.highest')
      expect(page).to have_content I18n.t('tasks.index.status.open')
    end

    it 'is increase when click Edit anchor-link' do
      visit task_path(test_task1)
      click_on I18n.t('action.update')
      expect(current_path).to eq edit_task_path(test_task1)
      expect(page).to have_content I18n.t('tasks.edit.title', task_id: test_task1.id)
      expect(find_field(Task.human_attribute_name(:summary)).value).to eq 'task1'
      expect(find_field(Task.human_attribute_name(:description)).value).to eq 'this is 1st task'
      expect(page).to have_select(Task.human_attribute_name(:priority), selected: I18n.t('tasks.index.priority.highest'))
      expect(page).to have_select(Task.human_attribute_name(:status), selected: I18n.t('tasks.index.status.open'))
    end

    it 'Test of Click Back Anchor Link' do
      visit task_path(test_task1)
      click_on I18n.t('action.back')
      expect(current_path).to eq root_path
      expect(page).to have_content I18n.t('tasks.index.title')
    end

    it 'is clicked Delete Anchor Link and Cancel' do
      visit task_path(test_task1)
      expect {
        click_on I18n.t('action.remove')
        expect(page.driver.browser.switch_to.alert.text).to eq I18n.t('flash.remove.confirm')
        page.driver.browser.switch_to.alert.dismiss
        expect(page).to have_content I18n.t('tasks.show.title', task_id: test_task1.id)
      }.to change { Task.count }.by (0)
      expect(current_path).to eq task_path(test_task1)
      expect(page).to have_content 'task1'
      expect(page).to have_content 'this is 1st task'
    end

    it 'is clicked Delete Anchor Link and OK' do
      visit task_path(test_task1)
      expect {
        click_on I18n.t('action.remove')
        expect(page.driver.browser.switch_to.alert.text).to eq I18n.t('flash.remove.confirm')
        page.driver.browser.switch_to.alert.accept
        expect(page).to have_content I18n.t('tasks.index.title')
      }.to change { Task.count }.by (-1)
      expect(current_path).to eq tasks_path # root_pathに変更予定
      expect(page).to have_no_content 'task1'
      expect(page).to have_no_content 'this is 1st task'
    end
  end
end

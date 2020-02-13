require 'rails_helper'

RSpec.describe 'Tasks', type: :system, js: true  do

  let!(:init_task) { Task.create( summary: 'task1', description: 'first task', priority: 1, status: 1 ) }
  before do
    Task.create( summary: 'task2', description: 'second task', priority: 3, status: 3 )
    Task.create( summary: 'task3', description: 'third task', priority: 5, status: 5 )
  end

  describe 'Task List Page' do
    it 'Tests of Layout' do
      visit root_path
      expect(page).to have_content I18n.t('tasks.index.title')
      expect(page).to have_content init_task.summary
      expect(page).to have_content init_task.description
      expect(page).to have_content I18n.t('tasks.index.priority.highest')
      expect(page).to have_content I18n.t('tasks.index.status.open')
    end

    it 'Tests of Click Draft Anchor Link' do
      visit root_path
      click_on(I18n.t('action.create'))
      expect(current_path).to eq new_task_path
      expect(page).to have_content I18n.t('tasks.new.title')
    end

    it 'Test of Click Detail Anchor Link' do
      visit root_path
      all('tbody tr')[0].click_link I18n.t('action.detail')
      expect(current_path).to eq task_path(init_task)
      expect(page).to have_content I18n.t('tasks.show.title', task_id: init_task.id)
    end

    it 'Test of Click Edit Anchor Link' do
      visit root_path
      all('tbody tr')[0].click_link I18n.t('action.update')
      expect(current_path).to eq edit_task_path(init_task)
      expect(page).to have_content I18n.t('tasks.edit.title', task_id: init_task.id)
    end
  end

  describe 'Task Registration Page' do
    let(:regist_task) { Task.new( summary: 'task4', description: 'fourth task', priority: 2, status: 2 ) }

    it 'displays default settings' do
      visit new_task_path
      expect(page).to have_content I18n.t('tasks.new.title')
      expect(find_field(Task.human_attribute_name(:summary)).value).to be_empty
      expect(find_field(Task.human_attribute_name(:description)).value).to be_empty
      expect(find_field(Task.human_attribute_name(:priority)).value).to eq 'middle'
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
        click_on(I18n.t('action.create'))
      }.to change { Task.count }.by(1)
      expect(current_path).to eq task_path(Task.maximum(:id))
      expect(page).to have_content I18n.t('tasks.show.title', task_id: Task.maximum(:id))
      expect(page).to have_content regist_task.summary
      expect(page).to have_content regist_task.description
    end

    it 'Test of Click Back Anchor Link' do
      visit new_task_path
      click_on I18n.t('action.back')
      expect(current_path).to eq root_path
      expect(page).to have_content I18n.t('tasks.index.title')
    end
  end

  describe 'Task Editional Page' do
    let!(:edit_task) { Task.create( summary: 'task5', description: 'fifth task', priority: 4, status: 4 ) }
    let!(:del_task)  { Task.create( summary: 'task6', description: 'sixth task', priority: 2, status: 5 ) }

    it 'displays edit_task settings' do
      visit edit_task_path(edit_task)
    end

    it 'is clicked Submit Button if set up normaly' do
      visit edit_task_path(edit_task)
      expect {
        fill_in Task.human_attribute_name(:summary), with: edit_task.summary + '_edited'
        fill_in Task.human_attribute_name(:description), with: edit_task.description + '_edited'
#        within find_field('Priority') do
#          find("option[value='1']").select_option
#        end
#        within find_field('Status') do
#          find("option[value='2']").select_option
#        end
        click_on(I18n.t('action.update'))
      }.to change { Task.count }.by(0)
      expect(current_path).to eq task_path(edit_task)
      expect(page).to have_content I18n.t('tasks.show.title', task_id: edit_task.id)
      expect(page).to have_content edit_task.summary + '_edited'
      expect(page).to have_content edit_task.description + '_edited'
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
      expect(find_field(Task.human_attribute_name(:summary)).value).to eq del_task.summary
      expect(find_field(Task.human_attribute_name(:description)).value).to eq del_task.description
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
      expect(page).to have_no_content del_task.summary
      expect(page).to have_no_content del_task.description
    end
  end

  describe 'Task Detail Page' do
    it 'displays init_task settings' do
      visit task_path(init_task)
      expect(page).to have_content I18n.t('tasks.show.title', task_id: init_task.id)
      expect(page).to have_content init_task.summary
      expect(page).to have_content init_task.description
      expect(page).to have_content I18n.t('tasks.index.priority.highest')
      expect(page).to have_content I18n.t('tasks.index.status.open')
    end

    it 'is increase when click Edit anchor-link' do
      visit task_path(init_task)
      click_on I18n.t('action.update')
      expect(current_path).to eq edit_task_path(init_task)
      expect(page).to have_content I18n.t('tasks.edit.title', task_id: init_task.id)
    end

    it 'Test of Click Back Anchor Link' do
      visit task_path(init_task)
      click_on I18n.t('action.back')
      expect(current_path).to eq root_path
      expect(page).to have_content I18n.t('tasks.index.title')
    end

    it 'is clicked Delete Anchor Link and Cancel' do
      visit task_path(init_task)
      expect {
        click_on I18n.t('action.remove')
        expect(page.driver.browser.switch_to.alert.text).to eq I18n.t('flash.remove.confirm')
        page.driver.browser.switch_to.alert.dismiss
        expect(page).to have_content I18n.t('tasks.show.title', task_id: init_task.id)
      }.to change { Task.count }.by (0)
      expect(current_path).to eq task_path(init_task)
      expect(page).to have_content init_task.summary
      expect(page).to have_content init_task.description
    end

    it 'is clicked Delete Anchor Link and OK' do
      visit task_path(init_task)
      expect {
        click_on I18n.t('action.remove')
        expect(page.driver.browser.switch_to.alert.text).to eq I18n.t('flash.remove.confirm')
        page.driver.browser.switch_to.alert.accept
        expect(page).to have_content I18n.t('tasks.index.title')
      }.to change { Task.count }.by (-1)
      expect(current_path).to eq tasks_path # root_pathに変更予定
      expect(page).to have_no_content init_task.summary
      expect(page).to have_no_content init_task.description
    end
  end
end

require 'rails_helper'

RSpec.describe 'Tasks', type: :system do
  let!(:task_a) { create(:task1) }
  describe 'Task board' do
    it 'view top page' do
      visit '/board/'
      expect(page).to have_content 'Guild'
      expect(page).to have_content 'ID'
      expect(page).to have_content 'UserName'
      expect(page).to have_content 'Label'
      expect(page).to have_content 'Subject'
      expect(page).to have_content 'Priority'
      expect(page).to have_content 'State'
      expect(page).to have_content task_a.subject
    end

    it 'add task' do
      visit '/board/'
      find('#create-button').click
      select 'Bugfix', from: 'label'
      fill_in 'subject', with: 'system spec subject'
      fill_in 'description', with: 'system spec description'
      select 'Low', from: 'priority'
      find('#add-task').click
      expect(page).to have_content 'system spec subject'
    end

    it 'change task' do
      visit '/board/'
      find('#id-link').click
      find('#change-input').click
      select 'Support', from: 'label'
      find('#change-task').click
      expect(page).to have_content 'Support'
    end

    it 'change task' do
      visit '/board/'
      find('#button-delete').click
      find('#delete-task').click
      expect(page).to_not have_content task_a.subject
    end
  end
end

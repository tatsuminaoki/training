require 'rails_helper'

RSpec.describe 'Task management', type: :system, js: true do
  context 'when user search' do
    before do
      Task.create!(title: 'first task', description: 'first Description', status: 'todo')
      Task.create!(title: 'second task', description: 'second Description', status: 'ongoing')
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

end

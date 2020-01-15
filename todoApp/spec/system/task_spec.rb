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

  context 'When user paginate' do
    before do
      1.upto(8){ |k| Task.create!(title: "Title #{k}") }
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
      user1 = User.create!(name: 'John', email: 'user1@example.com', password_digest: BCrypt::Password.create('u1password'))
      user2 = User.create!(name: 'Mary', email: 'user2@example.com', password_digest: BCrypt::Password.create('u2password'))
      Task.create!(title: 'user1 task', user_id: user1.id)
      Task.create!(title: 'user2 task', user_id: user2.id)
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

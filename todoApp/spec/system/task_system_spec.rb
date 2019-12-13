require 'rails_helper'

RSpec.describe 'Task management', type: :system, js: true do
  before do
    Task.create!(title: 'rspec Test', description: 'rspec Description')
  end

  it 'show me the list of Tasks' do
    visit tasks_path
    expect(page).to have_content 'Tasks'
  end

  it 'enables me to create Tasks' do
    visit tasks_path
    click_link 'New Task'
    fill_in 'Title', :with => 'My Task'
    fill_in 'Description', :with => 'My Task Description'
    click_button 'Create Task'
    expect(page).to have_content 'Task was successfully created.'
  end

  it 'enables me to edit Tasks' do
    visit tasks_path
    click_link 'Edit'
    fill_in 'Title', :with => 'My Edited Task'
    fill_in 'Description', :with => 'Edit My Task Description'
    click_button 'Update Task'
    expect(page).to have_content 'Task was successfully updated.'
  end

  it 'enables me to delete Tasks' do
    visit tasks_path
    accept_alert do
      click_link 'Destroy'
    end
    expect(page).to have_content 'Task was successfully destroyed.'
  end

end

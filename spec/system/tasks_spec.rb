require 'rails_helper'

RSpec.describe 'Tasks', type: :system do

  specify 'User operates from creation to editing to deletion' do
    visit root_path

    expect(page).to have_content('Tasks')

    click_on 'New Task'

    fill_in 'Name', with: 'task name'
    fill_in 'Description', with: 'hoge'
    select 'work_in_progress', from: 'Status'

    click_on 'Create Task'

    expect(page).to have_content('Task was successfully created.')
    expect(page).to have_content('task name')
    expect(page).to have_content('hoge')
    expect(page).to have_content('work_in_progress')

    click_on 'Edit'

    expect(page).to have_content('Editing Task')
    fill_in 'Name', with: 'update'
    fill_in 'Description', with: 'hoge-update'
    select 'completed', from: 'Status'

    click_on 'Update Task'

    expect(page).to have_content('Task was successfully updated.')
    expect(page).to have_content('update')
    expect(page).to have_content('hoge-update')
    expect(page).to have_content('completed')

    click_on 'Back'

    expect(page).to have_content('Tasks')
    expect(page).to have_content('update')
    expect(page).to have_content('hoge-update')
    expect(page).to have_content('completed')
  end
end

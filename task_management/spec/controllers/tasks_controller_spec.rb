require 'rails_helper'

RSpec.describe TasksController, type: :controller do
  feature 'テスト' do
    before{visit root_path}
    scenario 'タスクの登録' do
      expect(page).to have_content 'a'
      # click_on 'new'
      # fill_in 'task_task_name', with: 'feature_test'
      # fill_in 'task_description', with: 'feature_description'
      # click_button 'Create Task'
      # expect(page).to have_content 'タスクを登録しました'
    end
  end

end

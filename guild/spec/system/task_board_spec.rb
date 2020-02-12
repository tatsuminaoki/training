# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Tasks', type: :system do
  let!(:user_a) { create(:user1) }
  let!(:login_a) { create(:login1, user_id: user_a.id) }
  let!(:task_a) { create(:task1, user_id: user_a.id) }
  before do
    visit '/login'
    fill_in 'inputEmail', with: login_a.email
    fill_in 'inputPassword', with: login_a.password
    find('#sign-in').click
  end

  describe 'Task board' do
    it 'view top page' do
      visit '/board/'
      expect(page).to have_content 'ID'
      expect(page).to have_content 'ユーザー'
      expect(page).to have_content 'ラベル'
      expect(page).to have_content '題名'
      expect(page).to have_content '優先度'
      expect(page).to have_content '状態'
      expect(page).to have_content task_a.subject
    end

    it 'add task' do
      visit '/board/'
      find('#create-button').click
      select I18n.t(:label)[:bugfix], from: 'label'
      fill_in 'subject', with: 'system spec subject'
      fill_in 'description', with: 'system spec description'
      select I18n.t(:priority)[:low], from: 'priority'
      find('#add-task').click
      expect(page).to have_content 'system spec subject'
    end

    it 'change task' do
      visit '/board/'
      find('#id-link-' + task_a.id.to_s).click
      find('#change-input').click
      select I18n.t(:label)[:support], from: 'label'
      find('#change-task').click
      expect(page).to have_content I18n.t(:label)[:support]
    end

    it 'delete task' do
      visit '/board/'
      find('#button-delete-' + task_a.id.to_s).click
      find('#delete-task').click
      expect(page).to_not have_content task_a.subject
    end
  end
end

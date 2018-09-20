# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'Tasks', type: :feature do
  scenario '新しいタスクを作成' do
    expect do
      visit root_path
      click_link I18n.t('tasks.index.new_task')
      fill_in I18n.t('activerecord.attributes.task.title'), with: 'First content'
      fill_in I18n.t('activerecord.attributes.task.content'), with: 'Rspec test'
      click_button I18n.t('helpers.submit.create')
      expect(page).to have_content I18n.t('flash.task.create')
      expect(page).to have_content('First content')
      expect(page).to have_content('Rspec test')
    end.to change { Task.count }.by(1)
  end

  scenario 'タスクの修正' do
    visit root_path
    click_link I18n.t('tasks.index.new_task')
    fill_in I18n.t('activerecord.attributes.task.title'), with: 'Before modify'
    fill_in I18n.t('activerecord.attributes.task.content'), with: 'Rspec test'
    click_button I18n.t('helpers.submit.create')
    click_link I18n.t('tasks.show.back')
    expect do
      click_link I18n.t('tasks.index.edit')
      fill_in I18n.t('activerecord.attributes.task.title'), with: 'After modify'
      fill_in I18n.t('activerecord.attributes.task.content'), with: 'Sleepy morning'
      click_button I18n.t('helpers.submit.update')
      expect(page).to have_content I18n.t('flash.task.update')
      expect(page).to have_content 'After modify'
      expect(page).to have_content 'Sleepy morning'
    end.to change { Task.count }.by(0)
  end

  scenario 'タスクの削除' do
    visit root_path
    click_link I18n.t('tasks.index.new_task')
    fill_in I18n.t('activerecord.attributes.task.title'), with: 'Delete Test'
    fill_in I18n.t('activerecord.attributes.task.content'), with: 'Delete this'
    click_button I18n.t('helpers.submit.create')
    click_link I18n.t('tasks.show.back')
    expect do
      click_link I18n.t('tasks.index.delete')
      expect(page).to have_content I18n.t('flash.task.delete')
    end.to change { Task.count }.by(-1)
  end
end

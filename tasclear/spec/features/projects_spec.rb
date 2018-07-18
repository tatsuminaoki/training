# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'Tasts', type: :feature do
  scenario '新しいタスクを作成する' do
    expect do
      visit root_path
      click_link I18n.t('tasks.index.new_task')
      fill_in I18n.t('activerecord.attributes.task.name'), with: '勉強'
      fill_in I18n.t('activerecord.attributes.task.content'), with: 'RSpecについて'
      click_button I18n.t('helpers.submit.create')
      expect(page).to have_content I18n.t('flash.task.create_success')
      expect(page).to have_content '勉強'
      expect(page).to have_content 'RSpecについて'
    end.to change { Task.count }.by(1)
  end
  scenario 'タスクを編集する' do
    visit root_path
    click_link I18n.t('tasks.index.new_task')
    fill_in I18n.t('activerecord.attributes.task.name'), with: '勉強'
    fill_in I18n.t('activerecord.attributes.task.content'), with: 'RSpecについて'
    click_button I18n.t('helpers.submit.create')
    expect do
      click_link I18n.t('tasks.index.edit')
      fill_in I18n.t('activerecord.attributes.task.name'), with: '運動'
      fill_in I18n.t('activerecord.attributes.task.content'), with: '腕立て100回'
      click_button I18n.t('helpers.submit.update')
      expect(page).to have_content I18n.t('flash.task.update_success')
      expect(page).to have_content '運動'
      expect(page).to have_content '腕立て100回'
    end.to change { Task.count }.by(0)
  end
  scenario 'タスクを削除する' do
    visit root_path
    click_link I18n.t('tasks.index.new_task')
    fill_in I18n.t('activerecord.attributes.task.name'), with: '勉強'
    fill_in I18n.t('activerecord.attributes.task.content'), with: 'RSpecについて'
    click_button I18n.t('helpers.submit.create')
    expect do
      click_link I18n.t('tasks.index.delete')
      expect(page).to have_content I18n.t('flash.task.destroy_success')
    end.to change { Task.count }.by(-1)
  end
  scenario 'タスク一覧が作成日時の降順で並んでいること' do
    create(:task, name: 'タスク１', created_at: '2018-7-16 08:10:10')
    create(:task, name: 'タスク２', created_at: '2018-7-16 09:10:15')
    visit root_path
    names = page.all('td.name')
    expect(names[0]).to have_content 'タスク２'
    expect(names[1]).to have_content 'タスク１'
  end
  scenario 'タスク一覧画面で終了時間でソートできること' do
    create(:task, name: '終了期限先', deadline: '2018-7-18', created_at: '2018-7-16 08:10:10')
    create(:task, name: '終了期限後', deadline: '2018-7-25', created_at: '2018-7-16 09:10:15')
    # 「終了期限後」を後に作成したので上に表示されている
    visit root_path
    names = page.all('td.name')
    expect(names[0]).to have_content '終了期限後'
    expect(names[1]).to have_content '終了期限先'
    # 終了期限をクリックすると終了期限が早い順にソートされ、「終了期限先」が上に表示される
    click_link I18n.t('tasks.index.deadline')
    names = page.all('td.name')
    expect(names[0]).to have_content '終了期限先'
    expect(names[1]).to have_content '終了期限後'
    # もう一度終了期限をクリックすると反対に終了期限が遅い順にソートされ、「終了期限後」が上に表示される
    click_link I18n.t('tasks.index.deadline')
    names = page.all('td.name')
    expect(names[0]).to have_content '終了期限後'
    expect(names[1]).to have_content '終了期限先'
  end
end

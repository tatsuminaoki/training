# frozen_string_literal: true

require 'rails_helper'
require 'selenium-webdriver'

RSpec.feature 'Tasks', type: :feature do
  let (:login_user) { create(:user) }
  let(:task) { create(:task) }

  before do
    visit root_path
    fill_in I18n.t('helpers.label.session.email'), with: login_user.email
    fill_in I18n.t('helpers.label.session.password'), with: login_user.password
    click_button I18n.t('sessions.new.submit')
  end

  scenario '新しいタスクを作成' do
    expect do
      click_link I18n.t('tasks.index.new_task')
      fill_in I18n.t('tasks.index.title'), with: 'First content'
      fill_in I18n.t('tasks.index.content'), with: 'Rspec test'
      click_button I18n.t('helpers.submit.create')
      expect(page).to have_content I18n.t('flash.task.create')
      expect(page).to have_content('First content')
      expect(page).to have_content('Rspec test')
    end.to change { Task.count }.by(1)
  end

  scenario 'タスクに追加したラベルで検索' do
    expect do
      create(:task, title: 'task1', label_list: 'label1')
      visit root_path
      fill_in 'search_label_name', with: 'label1'
      click_button I18n.t('tasks.index.search_submit')
      expect(page).to have_content 'task1'
    end
  end

  describe 'ラベルの更新処理' do
    let(:old) { %w[old1 old2] }
    let(:new) { %w[new1 new2 new3] }
    let(:all) { old + new }
    let(:label_area) { '#task_label_list' }

    before do
      task.label_list.add(old.join(','))
      task.save
      visit edit_task_path(task)
    end

    context '既に登録済みのラベルがある場合' do
      it '表示されていること' do
        expect(find('.tagit')).to have_content('old1')
      end
    end

    describe 'ラベルの変更検証', js: true do
      context 'ラベルを追加したい場合' do
        it '修正する' do
          add_label(label_area, new)
          click_on I18n.t('helpers.submit.update')
          t = Task.find(task.id)
          expect(t.label_list).to match_array all
        end
      end

      context 'ラベルを削除したい場合' do
        it '削除する' do
          delete_label(label_area, %w[old2])
          click_on I18n.t('helpers.submit.update')
          t = Task.find(task.id)
          expect(t.label_list).to contain_exactly(old.first)
        end
      end
    end
  end
end

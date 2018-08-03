# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'Labels', type: :feature do
  # ログイン状態の作成
  background do
    user = create(:user, id: 1)
    visit root_path
    fill_in 'メールアドレス', with: user.email
    fill_in 'パスワード', with: user.password
    click_button 'ログイン'
  end

  scenario '複数のラベルをつけてタスクを作成する' do
    click_link '新規タスク登録', match: :first
    fill_in 'タスク名', with: '勉強'
    fill_in 'ラベル', with: 'study,english'
    click_button '登録する'
    labels = page.all('td.label')
    expect(labels[0]).to have_content 'study'
    expect(labels[0]).to have_content 'english'
  end

  feature 'ラベルの編集機能' do
    background do
      click_link '新規タスク登録', match: :first
      fill_in 'タスク名', with: '勉強'
      fill_in 'ラベル', with: 'study'
      click_button '登録する'
    end

    scenario '編集できる' do
      find('.edit-btn').click
      fill_in 'ラベル', with: 'emergency'
      click_button '更新する'
      labels = page.all('td.label')
      expect(labels[0]).to have_content 'emergency'
      expect(labels[0]).not_to have_content 'study'
    end
  end

  feature 'ラベルの検索機能' do
    background do
      click_link '新規タスク登録', match: :first
      fill_in 'タスク名', with: '勉強'
      fill_in 'ラベル', with: 'study'
      click_button '登録する'
      click_link '新規タスク登録', match: :first
      fill_in 'タスク名', with: '運動'
      fill_in 'ラベル', with: 'workout'
      click_button '登録する'
    end

    scenario '検索ができる' do
      fill_in 'ラベル', with: 'study'
      click_button '検索'
      labels = page.all('td.label')
      expect(labels.count).to have_content 1
      expect(labels[0]).to have_content 'study'
      expect(labels[0]).not_to have_content 'workout'
    end
  end
end

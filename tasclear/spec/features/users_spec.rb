# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'Users', type: :feature do
  context 'ログインをしない' do
    scenario 'ログインせずにトップページにログインするとログインページに遷移する' do
      visit root_path
      expect(page).to have_current_path '/sessions/new'
    end

    scenario 'メールアドレスを間違えるとログインに失敗する' do
      create(:user, id: 1)
      visit root_path
      fill_in I18n.t('helpers.label.session.email'), with: 'aaa@example.com'
      fill_in I18n.t('helpers.label.session.password'), with: 'password'
      click_button I18n.t('sessions.new.submit')
      expect(page).to have_content I18n.t('flash.session.fail_login')
    end

    scenario 'パスワードを間違えるとログインに失敗する' do
      create(:user, id: 1)
      visit root_path
      fill_in I18n.t('helpers.label.session.email'), with: 'raku@example.com'
      fill_in I18n.t('helpers.label.session.password'), with: 'hogehoge'
      click_button I18n.t('sessions.new.submit')
      expect(page).to have_content I18n.t('flash.session.fail_login')
    end
  end

  context 'ログインをする' do
    before do
      create(:user, id: 1)
      visit root_path
      fill_in I18n.t('helpers.label.session.email'), with: 'raku@example.com'
      fill_in I18n.t('helpers.label.session.password'), with: 'password'
      click_button I18n.t('sessions.new.submit')
    end

    scenario 'ログインするとフラッシュメッセージが表示されトップページに遷移する' do
      expect(page).to have_current_path '/'
      expect(page).to have_content I18n.t('flash.session.login_success')
    end

    scenario 'ログアウト出来る' do
      click_link I18n.t('layouts.application.logout')
      expect(page).to have_content I18n.t('flash.session.logout_success')
    end
  end
end

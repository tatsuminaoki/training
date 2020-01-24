# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Sessions', type: :system do
  feature 'GET #new' do
    given!(:user) { create(:user) }

    scenario 'ログインができる' do
      visit sign_in_path

      fill_in 'session[name]', with: user.name
      fill_in 'session[password]', with: 'password'

      click_on I18n.t('sessions.new.sign_in')

      expect(page).to have_content(I18n.t('sessions.create.logged_in'))
    end

    scenario 'ログインができない' do
      visit sign_in_path

      fill_in 'session[name]', with: user.name
      fill_in 'session[password]', with: 'password!!'

      click_on I18n.t('sessions.new.sign_in')

      expect(page).to have_content(I18n.t('sessions.create.retry'))
    end
  end
end

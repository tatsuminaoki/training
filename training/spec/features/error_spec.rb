require 'rails_helper'

RSpec.describe 'Error', type: :feature do

  describe 'ユーザーが存在しないページにアクセスする' do
    before { visit 'hoge' }

    it '404のエラーページが表示される' do
      expect(page).to have_content '404 Not Found'
    end
  end

  describe 'ユーザーが存在しないレコードにアクセスする' do
    let!(:user) { FactoryBot.create(:user) }

    before do
      visit logins_new_path
      fill_in 'email', with: user.email
      fill_in 'password', with: user.password
      click_on I18n.t('logins.view.new.submit')

      visit task_path(0)
    end

    it '404のエラーページが表示される' do
      expect(page).to have_content '404 Not Found'
    end
  end
end

require 'rails_helper'

RSpec.feature "Sessions", type: :feature do
  describe 'Login Page' do
    let!(:user) { FactoryBot.create(:user) }
    before { visit login_path }

    context 'When user input right information' do
      it 'User can sign in successfully' do
        fill_in 'sessions[name]', with: user.name
        fill_in 'sessions[password]', with: user.password
        click_button I18n.t('page.user.link.login')

        expect(page).to have_content I18n.t('errors.messages.valid_login')
        expect(current_path).to eql('/')
      end
    end

    context 'When user did not input any information' do
      context 'In case of name is nil' do
        it 'redirects to login page' do
          fill_in 'sessions[name]', with: nil
          fill_in 'sessions[password]', with: user.password
          click_button I18n.t('page.user.link.login')

          expect(page).to have_content I18n.t('flash.user.non_exist')
          expect(current_path).to eql('/login')
        end
      end

      context 'In case of password is nil' do
        it 'redirects to login page' do
          fill_in 'sessions[name]', with: user.name
          fill_in 'sessions[password]', with: nil
          click_button I18n.t('page.user.link.login')

          expect(page).to have_content I18n.t('flash.user.blank')
          expect(current_path).to eql('/login')
        end
      end
    end

    context 'When user input wrong information' do
      context 'In case of name is wrong' do
        it 'redirects to login page' do
          fill_in 'sessions[name]', with: 'Wronguser1'
          fill_in 'sessions[password]', with: user.password
          click_button I18n.t('page.user.link.login')

          expect(page).to have_content I18n.t('flash.user.non_exist')
          expect(current_path).to eql('/login')
        end
      end

      context 'In case of password is wrong' do
        it 'redirects to login page' do
          fill_in 'sessions[name]', with: user.name
          fill_in 'sessions[password]', with: 'Wrongpassword1'
          click_button I18n.t('page.user.link.login')

          expect(page).to have_content I18n.t('errors.messages.invalid_login')
          expect(current_path).to eql('/login')
        end
      end
    end
  end
end

# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Users', type: :system do
  let(:user) { create(:admin_user) }
  before do
    create(:task, { user_id: user.id })
  end

  describe 'GET #new' do
    before do
      visit login_path
    end

    context 'when user correctly fills out the form' do
      it 'returns the user\'s task list' do
        fill_in 'session_login_id', with: user.login_id
        fill_in 'session_password', with: 'password1'
        click_button 'ログイン'

        expect(page).to have_content 'ログアウト'
        expect(page).to have_content 'task1'
        expect(page).to have_content '低'
        expect(page).to have_content '待機中'
        expect(page).to have_content '2020/12/31'
      end
    end
  end
end

# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Admin::User', type: :system do
  feature 'GET #index' do
    given!(:user) { create(:user, role: :admin) }

    background do
      sign_in_with(user)
    end

    scenario '一覧に表示される' do
      visit admin_users_path

      expect(page).to have_content(user.name)
      expect(page).to have_content(user.role)
    end
  end
end

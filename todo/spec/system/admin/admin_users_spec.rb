require 'rails_helper'

RSpec.describe "Admin::Users", type: :system do

  let(:administrator) { create(:administrator) }

  describe 'when access index' do
    context 'with logged-in user' do
      it 'show admin users page' do
        log_in_as administrator
        visit admin_users_path
        expect(page.current_path).to eq('/admin/users')
        expect(page).to have_content('adminstrator')
      end
    end

    context 'with logged-out user' do
      it 'failed to access' do
        visit admin_users_path
        expect(page.current_path).not_to eq('/admin/users')
      end
    end
  end

  describe 'when access show' do
    context 'with logged-in user' do
      it 'success to access' do
        log_in_as administrator
        visit admin_user_path(administrator)
        expect(page.current_path).to eq("/admin/users/#{ administrator.id }")
        expect(page).to have_content('administrator')
      end
    end

    context 'with logged-out user' do
      it 'failed to access' do
        visit admin_user_path(administrator)
        expect(page.current_path).not_to eq("/admin/users/#{ administrator.id }")
      end
    end
  end
end

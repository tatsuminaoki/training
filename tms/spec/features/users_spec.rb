require 'rails_helper'

RSpec.feature "Users", type: :feature do
  describe 'Admin Page' do
    let!(:admin_user) { FactoryBot.create(:user, id: 2, name: 'AdminUser', admin: 1) }
    let!(:general_user) { FactoryBot.create(:user, id: 3, name: 'GeneralUser', admin: 0) }

    describe 'Move admin page' do
      context 'In case of general user' do
        before do
          visit login_path
          fill_in 'sessions[name]', with: general_user.name
          fill_in 'sessions[password]', with: general_user.password
          click_button I18n.t('page.user.link.login')
          visit admin_index_path
        end

        it 'General user can not move to admin page' do
          expect(page).to have_content I18n.t('flash.user.non_admin')
        end
      end

      context 'In case of admin user' do
        before do
          visit login_path
          fill_in 'sessions[name]', with: admin_user.name
          fill_in 'sessions[password]', with: admin_user.password
          click_button I18n.t('page.user.link.login')
          visit admin_index_path
        end

        it 'Admin user can move to admin page' do
          expect(current_path).to eql('/admin/index')
        end

        describe 'Move users list' do
          it 'Admin user can move to users list' do
            visit admin_users_path
            expect(current_path).to eql('/admin/users')
          end

          it 'shows user name' do
            expect(page).to have_content admin_user.name
          end

          context 'When user click detail button' do
            it 'Admin user can move to user detail' do
              visit admin_user_path(2)
              expect(current_path).to eql('/admin/users/2')
            end

            it 'shows user name' do
              expect(page).to have_content admin_user.name
            end

            let!(:task) { FactoryBot.create(:task, user_id: 2) }
            it 'includs user name who created tasks' do
              expect(page).to have_content task.user.name
            end
          end

          context 'When user click edit button' do
            before { visit edit_admin_user_path(2) }
            it 'Admin user can move to edit page' do
              expect(current_path).to eql('/admin/users/2/edit')
            end

            context 'When user click update button' do
              it 'Admin user can move to user detail' do
                click_button I18n.t('helpers.submit.update')
                expect(current_path).to eql('/admin/users/2')
              end
            end
          end
        end
      end
    end
  end
end

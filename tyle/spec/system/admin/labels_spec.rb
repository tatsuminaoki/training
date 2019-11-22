# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'AdminUsers', type: :system do
  let(:user) { create(:user) }
  let!(:label) { create(:label) }

  before do
    # Log in as the user in the following rspec.
    visit login_path
    fill_in 'session_login_id', with: user.login_id
    fill_in 'session_password', with: 'password1'
    click_button 'ログイン'
    expect(page).to have_content 'ログアウト'
  end

  describe 'GET #index' do
    before do
      visit admin_labels_path
    end

    context 'when labels exist' do
      it 'returns the label list' do
        expect(page).to have_content 'label1'
      end
    end
  end

  describe 'GET #new' do
    before do
      visit new_admin_label_path
    end

    context 'when user correctly fills out the form' do
      it 'returns the created label' do
        fill_in 'label_name', with: 'label2'
        click_button '登録する'

        expect(page).to have_content 'ラベルが追加されました！'
        expect(page).to have_content 'label2'
      end
    end
  end

  describe 'GET #show' do
    before do
      visit admin_label_path(label)
    end

    context 'when a label is correctly created' do
      it 'shows the label' do
        expect(page).to have_content 'label1'
      end
    end

    context 'when user tries to delete the label with the delete button' do
      it 'successfully deletes the label' do
        expect(page).to have_content 'label1'

        click_on '削除'
        expect(page.driver.browser.switch_to.alert.text).to eq '本当にラベルを削除してもいいですか？'
        page.driver.browser.switch_to.alert.accept

        expect(page).to have_no_content 'label1'
      end
    end

    context 'when user pushes the delete button and selects No in the dialog message' do
      it 'cancels the delete' do
        click_on '削除'
        expect(page.driver.browser.switch_to.alert.text).to eq '本当にラベルを削除してもいいですか？'
        page.driver.browser.switch_to.alert.dismiss

        expect(page).to have_content 'label1'
      end
    end
  end

  describe 'GET #edit' do
    before do
      visit edit_admin_label_path(label)
    end

    context 'when user correctly fills out the form' do
      it 'updates the label info' do
        fill_in 'label_name', with: 'label2'
        click_button '更新する'

        expect(page).to have_content 'ラベルが更新されました！'
        expect(page).to have_content 'label2'
      end
    end
  end
end

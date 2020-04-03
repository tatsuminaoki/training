# frozen_string_literal: true

require 'rails_helper'

describe 'メンテナンス機能', type: :system do
  before do
    Batch::MaintenanceBatch.start
  end

  context 'メンテナンス中のとき' do
    it 'メンテナンスページに遷移する' do
      visit root_path
      expect(page).to have_content '現在メンテナンス中です'
    end
  end

  context 'メンテナンスが終了したとき' do
    it 'ログインページに遷移する' do
      Batch::MaintenanceBatch.end
      visit root_path
      expect(page).to have_content User.human_attribute_name(:email)
      expect(page).to have_content User.human_attribute_name(:password)
    end
  end
end

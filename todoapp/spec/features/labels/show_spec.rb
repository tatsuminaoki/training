require 'rails_helper'

feature 'ラベル管理機能', type: :feature do
  let(:user_a) { create(:user) }
  let!(:label_a) { create(:label, name: 'ラベルA', user_id: user_a.id) }

  describe '詳細表示機能' do
    context '詳細表示画面へ遷移した時' do
      background do
        login
        visit label_path(label_a)
      end

      scenario 'ユーザーのラベル情報が表示されている' do
        expect(page).to have_content 'ラベルA'
      end
    end
  end
end

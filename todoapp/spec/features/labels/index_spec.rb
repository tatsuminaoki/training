require 'rails_helper'

feature 'ラベル管理機能', type: :feature do
  let(:user_a) { create(:user) }
  let!(:label_a) { create(:label, name: 'ラベルA', user_id: user_a.id) }
  let!(:label_b) { create(:label, name: 'ラベルB', user_id: user_a.id) }

  describe 'ラベル一覧表示機能' do
    context 'ラベル一覧画面へ遷移した時' do
      background do
        login
        visit labels_path
      end

      scenario '作成したラベルが表示される' do
        expect(page).to have_content 'ラベルA'
        expect(page).to have_content 'ラベルB'
      end
    end

    context 'ラベル一覧画面へ遷移した時' do
      background do
        login
        visit labels_path
      end

      scenario 'ラベルの削除ができる' do
        find('/html/body/article/table/tbody/tr[1]/td[6]/form/input[2]').click
        expect(page).to have_content '「ラベルA」を削除しました。'
      end
    end
  end
end

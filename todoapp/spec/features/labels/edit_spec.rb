require 'rails_helper'

feature 'ラベル管理機能', type: :feature do
  let(:user_a) { create(:user) }
  let!(:label_a) { create(:label, name: 'ラベルA', user_id: user_a.id) }

  describe '更新機能' do
    context '更新画面へ遷移した時' do
      background do
        login
        visit edit_label_path(label_a)
      end

      scenario 'ラベルの名前は更新できる' do
        expect(page).to have_content '入力フォーム'

        expect(page).to have_field :label_name, with: 'ラベルA'

        fill_in :label_name, with: 'ラベル更新したよ'

        click_button '更新する'
        expect(page).to have_content '「ラベル更新したよ」を更新しました。'

        element = find('/html/body/article/table/tbody/tr[1]/td[2]')
        expect(element.text).to have_content 'ラベル更新したよ'
      end
    end
  end
end

require 'rails_helper'

RSpec.feature 'Labels', type: :feature do
  given(:user1) { create :user }

  background do
    login(user1)
  end

  feature '画面遷移' do
    scenario 'メンテナンス中に正しくメンテナンス画面に遷移すること' do
      visit new_label_path
      expect(page).to have_content 'ラベル作成'
      maintenance = create(:maintenance, is_maintenance: 1)
      visit new_label_path
      expect(page).to have_content 'メンテナンス中'
    end

    scenario 'root_pathからラベル投稿ページに遷移すること' do
      visit root_path
      click_link 'マイページ'
      click_link 'ラベル作成'
      expect(page).to have_content 'ラベル作成'
      expect(page).not_to have_content 'メールアドレス'
    end

    scenario 'root_pathからラベル一覧ページに遷移すること' do
      visit root_path
      click_link 'マイページ'
      click_link 'ラベル一覧'
      expect(page).to have_content 'ラベル一覧'
      expect(page).not_to have_content 'メールアドレス'
    end
  end

  feature 'バリデーション' do
    scenario 'ラベルが10文字なら登録できること' do
      expect(build(:label, name: ('a' * 10), user_id: user1.id)).to be_valid
    end

    scenario 'ラベルが11文字だと登録できないこと' do
      expect(build(:label, name: ('a' * 11), user_id: user1.id)).not_to be_valid
    end

    scenario 'ラベルが空だと登録できないこと' do
      expect(build(:label, name: '', user_id: user1.id)).not_to be_valid
    end

    scenario 'ラベルが空のときにバリデーションエラーメッセージが出ること' do
      visit new_label_path
      fill_in 'ラベル', with: ''
      click_button '登録する'
      expect(page).to have_content 'ラベルを入力してください'
    end

    scenario 'ラベルが11文字のときにバリデーションエラーメッセージが出ること' do
      visit new_label_path
      fill_in 'ラベル', with: ('a' * 11)
      click_button '登録する'
      expect(page).to have_content 'ラベルは10文字以内で入力してください'
    end
  end

  feature 'ラベルの作成、削除ができること' do

    background do
      create(:label, user_id: user1.id)
    end

    scenario 'ラベルの作成' do
      visit new_label_path
      fill_in 'ラベル', with: ('a' * 10)
      click_button '登録する'
      expect(page).to have_content 'ラベルを作成しました！'
    end

    scenario 'ラベルの削除' do
      visit labels_path
      click_link '削除'
      expect(page).to have_content 'ラベルを削除しました！'
    end
  end
end

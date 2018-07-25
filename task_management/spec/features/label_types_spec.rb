require 'rails_helper'

RSpec.feature "LabelTypes", type: :feature do
  background do
    @user = create(:user, admin: 'general')
    @label = create(:label_type)
  end

  feature '画面遷移' do
    background do
      login(@user.mail_address, @user.password)
    end

    context 'タスク一覧画面で「ラベルの編集」をクリックする' do
      scenario 'ラベル一覧画面に遷移する' do
        click_on I18n.t('button.edit_label')

        expect(current_path).to eq labels_path
        expect(page).to have_content I18n.t('button.new')
        expect(page).to have_content 'ラベル'
        expect(page).to have_content @label.label_name
      end
    end

    context 'ラベル一覧画面で「新規作成をクリックする」' do
      scenario 'ラベル登録画面に遷移する' do
        visit labels_path
        click_on I18n.t('button.new')

        expect(current_path).to eq new_label_path
        expect(page).to have_field 'label_type_label_name'
        expect(page).to have_button I18n.t('helpers.submit.create')
      end
    end

    context 'ラベル一覧画面でラベル名をクリックする' do
      scenario 'ラベル編集画面に遷移する' do
        visit labels_path
        click_on @label.label_name

        expect(current_path).to eq edit_label_path(id: @label.id)
        expect(page).to have_field 'label_type_label_name', with: @label.label_name
        expect(page).to have_button I18n.t('helpers.submit.update')
        expect(page).to have_content I18n.t('button.delete')
      end
    end
  end

  feature 'ラベルの新規作成' do
    background do
      login(@user.mail_address, @user.password)
    end

    context 'ラベル名想定される値を入力して「登録する」をクリックする' do
      scenario '登録に成功する' do
        visit new_label_path
        fill_in 'label_type_label_name', with: 'new_label'
        click_button I18n.t('helpers.submit.create')

        expect(current_path).to eq labels_path
        expect(page).to have_content 'ラベルの登録に成功しました'
        expect(page).to have_content 'new_label'
      end
    end

    context 'ラベル名が未入力の状態で「登録する」をクリックする' do
      scenario '登録に失敗してエラーメッセージが表示される' do
        visit new_label_path
        fill_in 'label_type_label_name', with: ''
        click_button I18n.t('helpers.submit.create')

        expect(current_path).to eq labels_path
        expect(page).to have_content 'ラベルの登録に失敗しました'
        expect(page).to have_content 'ラベル名を入力してください'
        expect(page).to have_field 'label_type_label_name', with: ''
      end
    end
  end

  feature 'ラベルの編集' do
    background do
      login(@user.mail_address, @user.password)
    end

    context '成功ラベル名想定される値を入力して「更新する」をクリックするパターン' do
      scenario '更新に成功する' do
        visit edit_label_path(id: @label.id)
        fill_in 'label_type_label_name', with: 'updated_label'
        click_button I18n.t('helpers.submit.update')

        expect(current_path).to eq labels_path
        expect(page).to have_content 'ラベルの更新に成功しました'
        expect(page).to have_content 'updated_label'
      end
    end

    context '256文字のラベル名を入力して「更新する」をクリックする' do
      scenario '更新に失敗してエラーメッセージが表示される' do
        visit edit_label_path(id: @label.id)
        fill_in 'label_type_label_name', with: 'a'*256
        click_button I18n.t('helpers.submit.update')

        expect(current_path).to eq label_path(id: @label.id)
        expect(page).to have_content 'ラベルの更新に失敗しました'
        expect(page).to have_content 'ラベル名は255字以内で入力してください'
        expect(page).to have_field 'label_type_label_name', with: 'a'*256
      end
    end
  end

  feature 'ラベルの削除' do
    background do
      login(@user.mail_address, @user.password)
    end

    context 'ラベルを削除する' do
      scenario '削除に成功する' do
        visit edit_label_path(id: @label.id)
        click_on I18n.t('button.delete')

        expect(current_path).to eq labels_path
        expect(page).to have_content "ラベル：#{@label.label_name}を削除しました"
        expect(page).not_to have_selector 'h4', text: @label.label_name
      end
    end
  end
end

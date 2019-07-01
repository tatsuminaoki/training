# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Labels', type: :system do
  let(:user) { create(:user) }

  specify 'User operates from creation to editing to deletion' do
    user_login(user: user)

    click_on 'ラベル管理'

    expect(page).to have_content('タスク管理')

    click_on '新規'

    fill_in 'ラベル名', with: 'hogehoge'

    click_on '登録する'

    expect(page).to have_content('ラベルの登録が完了しました。')

    expect(page).to have_content('hogehoge')

    first(:link, '編集').click

    expect(page).to have_content('Editing Label')

    fill_in 'ラベル名', with: 'hogeUpdate'

    click_on '更新する'

    expect(page).to have_content('ラベルの更新が完了しました。')
    expect(page).to have_content('hogeUpdate')

    expect(page).to have_content('ラベル管理')

    click_on 'ラベル管理'

    first(:link, '削除').click

    expect(page).to have_content('ラベルの削除が完了しました。')
  end
end

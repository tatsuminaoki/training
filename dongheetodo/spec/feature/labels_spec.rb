require "rails_helper"
require "i18n"
require "faker"

RSpec.feature "Labels", type: :feature, js: true do
  given(:email) { Faker::Internet.email }
  given(:password) { Faker::Internet.password(min_length: 8) }
  given!(:user) { create(:user, email: email, password: password) }

  scenario "ラベル一覧を表示する", open_on_error: true do
    login_as(user)
    click_link I18n.t("activerecord.labels.index.title")
    expect(page).to have_content I18n.t("activerecord.labels.index.title")
  end

  scenario "ログインしないとラベル一覧にアクセスできない", open_on_error: true do
    visit labels_path
    # ログインページにリダイレクトされる
    expect(page).to have_content I18n.t("activerecord.users.login.title")
  end

  scenario "ラベルを作成する", open_on_error: true do
    login_as(user)
    visit labels_path
    name = Faker::Food.fruits
    fill_in "label_name", with: name
    select I18n.t("activerecord.attributes.label.color.red"), from: "label_color"
    find("input[type=submit]").click
    # ログインページにリダイレクトされる
    expect(page).to have_text name
  end

  scenario "ラベル名を入力せずラベルを作成する", open_on_error: true do
    login_as(user)
    visit labels_path
    select I18n.t("activerecord.attributes.label.color.red"), from: "label_color"
    find("input[type=submit]").click
    # 生成されていないことを確認
    expect(page).not_to have_css "span.badge"
  end

  scenario "カラーを選択せずラベルを作成する", open_on_error: true do
    login_as(user)
    visit labels_path
    fill_in "label_name", with: Faker::Food.vegetables
    find("input[type=submit]").click
    # 生成されていないことを確認
    expect(page).to have_css "div.alert-warning"
    expect(page).not_to have_css "span.badge"
  end
end

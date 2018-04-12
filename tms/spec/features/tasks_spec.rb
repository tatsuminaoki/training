require 'rails_helper'

RSpec.feature "Tasks", type: :feature do
  scenario "user create a new task" do
    visit root_path
    expect {
      click_link I18n.t("page.task.link.new")
      fill_in I18n.t('page.task.thead.title'), with: "Setup DEV ENV"
      fill_in I18n.t('page.task.thead.description'), with: "Setup development environment on localhost."
      fill_in I18n.t('page.task.thead.user'), with: 1
      fill_in I18n.t('page.task.thead.priority'), with: 0
      fill_in I18n.t('page.task.thead.status'), with: 0
      fill_in I18n.t('page.task.thead.due_date'), with: "2018-04-17"
      click_button I18n.t("helpers.submit.create")

      expect(page).to have_content I18n.t("flash.task.create")
    }.to change(Task, :count).by(1)
  end
end

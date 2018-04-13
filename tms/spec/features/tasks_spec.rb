require 'rails_helper'

RSpec.feature "Tasks", type: :feature do
  describe "Tasks list" do
    let!(:task) { FactoryBot.create(:task) }

    context "When user visit tasks list" do
      let!(:new_task) { FactoryBot.create(:task, title: 'Test Task 2', created_at: Time.now.since(1.days)) }

      it "User can see tasks in descending order of created time" do
        visit root_path
        expect(new_task.created_at.time > task.created_at.time).to be true
      end
    end

    context "When user click 'タスク登録' button" do
      it "User can create a new task" do
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
  end
end

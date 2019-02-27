require 'rails_helper'

RSpec.feature "Tasks", type: :feature do
	scenario "新規タスクの作成" do
		visit root_path
		click_link "投稿"
		fill_in "Name", with: "Math"
		fill_in "Priority", with: "1"
		fill_in "Status", with: "1"
		click_button "Create Task"
		expect(page).to have_content "タスクを作成しました！"
		expect(page).to have_content "Math"
	end
	scenario "タスクの編集" do
		visit root_path
		click_link "投稿"
		fill_in "Name", with: "Math"
		fill_in "Priority", with: "1"
		fill_in "Status", with: "1"
		click_button "Create Task"
		click_link "詳細"
		click_link "編集"
		fill_in "Name", with: "English"
		fill_in "Priority", with: "1"
		fill_in "Status", with: "1"
		click_button "Update Task"
		expect(page).to have_content "タスクを編集しました！"
		expect(page).to have_content "English"
	end
	scenario "タスクの削除" do
		visit root_path
		click_link "投稿"
		fill_in "Name", with: "Math"
		fill_in "Priority", with: "1"
		fill_in "Status", with: "1"
		click_button "Create Task"
		click_link "詳細"
		click_link "削除"
		expect(page).to have_content "タスクを削除しました！"
	end
end
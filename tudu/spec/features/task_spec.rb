require 'rails_helper'

RSpec.feature 'task management', :type => :feature do

  describe 'create task' do
    context 'create a new task' do
      scenario 'End User Create a new task' do

        visit new_task_path

        input_name = 'タスク名1'
        input_content = 'タスク内容1'
        fill_in 'task[name]', with: input_name
        fill_in 'task[content]', with: input_content
        click_button '登録'
        expect(page).to have_text('タスクを登録しました')

        expect(page).to have_text(input_name)
        expect(page).to have_text(input_content)
      end
    end
  end

  describe 'update task' do
    context 'update a new task' do
      scenario 'End user update a task' do

        task = create(:task)
        visit root_path
        expect(page).to have_text(task.name)
        expect(page).to have_text(task.content)

        visit edit_task_path(task)

        input_name = 'タスク名1 update'
        input_content = 'タスク内容1 update'
        fill_in 'task[name]', with: input_name
        fill_in 'task[content]', with: input_content
        click_button '変更を保存する'
        expect(page).to have_text('タスクを保存しました')

        expect(page).to have_text(input_name)
        expect(page).to have_text(input_content)
      end
    end
  end

  describe 'show task' do
    context 'show a task' do
      scenario 'End user show a task' do
        task = create(:task)
        visit task_path(task)
        expect(page).to have_text(task.name)
        expect(page).to have_text(task.content)
      end
    end
  end

  describe 'delete task' do
    context 'delete a task' do
      scenario 'End user delete task' do
        task1 = create(:task)
        task2 = create(
          :task,
          name: 'dummy2 name',
          content: 'dummy2 content'
        )
        visit root_path
        expect(page).to have_text(task1.name)
        expect(page).to have_text(task1.content)
        expect(page).to have_text(task2.name)
        expect(page).to have_text(task2.content)

        click_link('削除', match: :first)
        expect(page).to have_text('タスクを削除しました')

        expect(page).to have_text(task2.name)
        expect(page).to have_text(task2.content)

        expect(page).not_to have_text(task1.name)
        expect(page).not_to have_text(task1.content)
      end
    end
  end

  describe 'view task list' do
    context 'when default display' do
      task = nil
      background do
        today = Time.zone.now
        task = nil
        10.times do |i|
          task = create(
            :task,
            name: "name_#{i}",
            content: "content_#{i}",
            created_at: today
          )
          today = today + 10
        end
      end

      scenario 'End user view task list' do
        visit root_path
        first_row = task
        expect(page.all('tr')[1].text).to include first_row.name

      end
    end

    context 'when expired_date sort' do
      scenario "End user view task list and sort" do
        today = Time.zone.now
        expire_date = Time.zone.today
        task = nil
        5.times do |i|
          task = create(
            :task,
            name: "name_#{i}",
            content: "content_#{i}",
            created_at: today,
            expire_date: expire_date
          )
          today = today + 10
          expire_date = expire_date + 3
        end

        # task に入っているのは、終了期限が一番後
        visit root_path
        last_expire_date_task = task
        # 昇順
        click_link("終了期限")
        expect(page.all("tr")[5].text).to include last_expire_date_task.name

        # 降順
        click_link("終了期限")
        expect(page.all("tr")[1].text).to include last_expire_date_task.name
      end
    end
  end
end

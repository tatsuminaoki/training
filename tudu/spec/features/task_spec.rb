require 'rails_helper'

RSpec.feature 'task management', :type => :feature do

  background do
    @user = create(:user)

    visit login_path
    fill_in 'session[email]', with: @user.email
    fill_in 'session[password]', with: 'hogehoge'
    click_button 'ログイン'
  end

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
        task = create(
          :task,
          user: @user,
        )
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
        task = create(
          :task,
          user: @user,
        )
        visit task_path(task)
        expect(page).to have_text(task.name)
        expect(page).to have_text(task.content)
      end
    end
  end

  describe 'delete task' do
    context 'delete a task' do
      scenario 'End user delete task' do
        tasks = create_list(:task, 2, user: @user)
        task1 = tasks[1]
        task2 = tasks[0]
        visit root_path

        expect(page).to have_text(task2.name)
        expect(page).to have_text(task2.content)
        expect(page).to have_text(task1.name)
        expect(page).to have_text(task1.content)

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
      scenario 'End user view task list' do
        tasks = create_list(:task, 10, user: @user)
        visit root_path
        expect(page.all('tr')[1].text).to include tasks.last.name
      end
    end

    context 'when expired_date sort' do
      scenario 'End user view task list and sort' do
        tasks = create_list(:task, 5, user: @user)
        # task に入っているのは、終了期限が一番後
        visit root_path
        last_expire_date_task = tasks.last
        # 昇順
        click_link('終了期限')
        expect(page.all('tr')[5].text).to include last_expire_date_task.name

        # 降順
        click_link('終了期限')
        expect(page.all('tr')[1].text).to include last_expire_date_task.name
      end
    end

    context 'when search' do
      scenario 'end user search task' do
        tasks_1 = create_list(:task, 2, user: @user, status: 0)
        tasks_2 = create_list(:task, 3, user: @user, status: 1)
        tasks_3 = create_list(:task, 5, user: @user, status: 2)
        params = [
          {
            q: tasks_1.first.name,
            expect: 1
          },
          {
            status: 1,
            expect: 3
          },
          {
            q: 'not exist',
            expect: 0
          },
        ]

        visit root_path
        expect(page.all('tbody > tr').length).to eq 10

        params.each do |param|
          if param[:q].present?
            fill_in 'q', with: param[:q]
          end
          if param[:status].present?
            select Task::STATUS.fetch(param[:status]), from: 'status'
          end
          click_button '検索'
          expect(page.all('tbody > tr').length).to eq param[:expect]
          visit root_path
        end
      end
    end
  end
end

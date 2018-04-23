require 'rails_helper'

RSpec.feature 'Tasks', type: :feature do
  describe 'Tasks list' do
    let!(:user) { FactoryBot.create(:user) }
    let!(:task) { FactoryBot.create(:task) }
    let!(:new_task) { FactoryBot.create(:task, title: 'Test Task 2',
                                               status: 1,
                                               priority: 1,
                                               created_at: 1.day.since,
                                               due_date: 2.days.since.to_date) }

    before do
      visit login_path
      fill_in 'sessions[name]', with: user.name
      fill_in 'sessions[password]', with: user.password
      click_button I18n.t('page.user.link.login')
    end

    context 'When user visit tasks list without any sort' do
      it 'User can see tasks in descending order of created time' do
        visit root_path
        expect(new_task.created_at.time > task.created_at.time).to be true
        expect(all('b')[0]).to have_content new_task.title
        expect(all('b')[1]).to have_content task.title
      end
    end

    context 'When user click 終了期限 降順でソート link' do
      it 'User can see tasks in descending order of due_date' do
        visit root_path
        click_link '終了期限 降順でソート'
        expect(all('b')[0]).to have_content new_task.title
        expect(all('b')[1]).to have_content task.title
      end
    end

    context 'When user click 終了期限 昇順でソート link' do
      it 'User can see tasks in ascending order of due_date' do
        visit root_path
        click_link '終了期限 昇順でソート'
        expect(all('b')[0]).to have_content task.title
        expect(all('b')[1]).to have_content new_task.title
      end
    end

    context 'When user click 優先度 降順でソート link' do
      it 'User can see tasks in descending order of priority' do
        visit root_path
        click_link '優先度 降順でソート'
        expect(all('b')[0]).to have_content new_task.title
        expect(all('b')[1]).to have_content task.title
      end
    end

    context 'When user click 優先度 昇順でソート link' do
      it 'User can see tasks in ascending order of priority' do
        visit root_path
        click_link '優先度 昇順でソート'
        expect(all('b')[0]).to have_content task.title
        expect(all('b')[1]).to have_content new_task.title
      end
    end

    context 'When user search with ステータス' do
      context 'If user select 未着手' do
        it 'shows only target status' do
          visit root_path
          select I18n.t('page.task.status.open'), from: 'status'
          click_button I18n.t('page.task.link.search.status')
          expect(all('b')[0]).to have_content task.title
          expect(all('b')[1]).to have_content nil
        end
      end

      context 'If user does not select any status' do
        it 'shows all status' do
          visit root_path
          click_button I18n.t('page.task.link.search.status')
          expect(all('b')[0]).to have_content new_task.title
          expect(all('b')[1]).to have_content task.title
        end
      end
    end

    context 'When user search with タイトル' do
      context 'If user input 1' do
        it 'shows only target status' do
          visit root_path
          fill_in 'title', with: '1'
          click_button I18n.t('page.task.link.search.title')
          expect(all('b')[0]).to have_content task.title
          expect(all('b')[1]).to have_content nil
        end
      end

      context 'If user does not input any words' do
        it 'shows all tasks' do
          visit root_path
          click_button I18n.t('page.task.link.search.title')
          expect(all('b')[0]).to have_content new_task.title
          expect(all('b')[1]).to have_content task.title
        end
      end
    end

    context 'When user click タスク登録 button' do
      it 'User can create a new task' do
        visit root_path
        expect {
          click_link I18n.t('page.task.link.new')
          fill_in I18n.t('page.task.thead.title'), with: 'Setup DEV ENV'
          fill_in I18n.t('page.task.thead.description'), with: 'Setup development environment on localhost.'
          select I18n.t('page.task.priority.low'), from: 'task[priority]'
          select I18n.t('page.task.status.open'), from: 'task[status]'
          fill_in I18n.t('page.task.thead.due_date'), with: '2018-04-17'
          click_button I18n.t('helpers.submit.create')

          expect(page).to have_content I18n.t('flash.task.create')
        }.to change(Task, :count).by(1)
      end
    end
  end
end

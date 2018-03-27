# frozen_string_literal: true

require 'rails_helper'

describe 'ユーザータスク一覧画面', type: :feature do
  let(:user) { create(:user) }

  before do
    1000.times { |i| create(:task, title: "Not start Task #{i}", user_id: user.id, status: :not_start) }
    5.times { |i| create(:task, title: "Progress Task #{i}", user_id: user.id, status: :progress) }
    2.times { |i| create(:task, title: "Done Task #{i}", user_id: user.id, status: :done) }
  end

  describe 'アクセス' do
    context '非ログイン状態でアクセスした場合' do
      it 'ログイン画面が表示されること' do
        visit admin_users_path
        expect(page).to have_css('.form-signin')
      end
    end

    context 'ログイン状態でアクセスした場合' do
      it '一般ユーザーの場合、タスク一覧ページにリダイレクトすること' do
        visit_after_login(user: create(:user, role: User.roles['general']), visit_path: admin_user_tasks_path(user))
        expect(page).to have_css('#todo_app_task_list')
      end

      it 'ユーザー一覧画面が表示されること' do
        visit_after_login(user: user, visit_path: admin_user_tasks_path(user))
        expect(page).to have_css('#task_list')
      end
    end
  end

  describe '表示内容の検証' do
    before { visit_after_login(user: user, visit_path: admin_user_tasks_path(user)) }

    context 'ユーザー情報の検証' do
      let(:user_info) { find('#user_info .card-body') }

      it 'ユーザー名が表示されていること' do
        expect(user_info).to have_content(user.name)
      end

      it 'ユーザーのタスクの集計値が表示されていること' do
        task_infos = user_info.all('.list-group-item')
        expect(task_infos[0]).to have_content('1,007')
        expect(task_infos[1]).to have_content('1,000')
        expect(task_infos[2]).to have_content('5')
        expect(task_infos[3]).to have_content('2')
      end
    end

    context 'タスクの一覧表の検証' do
      let(:record) { first(:css, 'table#task_table tbody tr') }
      let(:last_created_task) { Task.order(created_at: :desc).first }

      it '絞り込み条件なしで上位10件のデータがテーブルに表示されていること' do
        expect(page).to have_css('table#task_table tbody tr', count: 10)
      end

      it 'ステータスが表示されていること' do
        expect(record).to have_content(Task.human_attribute_name("statuses.#{last_created_task.status}"))
      end

      it 'タスク名が表示されていること' do
        expect(record).to have_content(last_created_task.title)
      end

      it 'created_atの降順で表示されていること' do
        expect(record).to have_content(last_created_task.created_at.to_s)
      end

      it 'ページをクリックすると次の10件が取得できること' do
        first('.page-item a[rel="next"]').click
        tasks = Task.order(created_at: :desc).limit(10).offset(10)
        all('table#task_table tbody tr').each.with_index do |td, idx|
          expect(td).to have_content(tasks[idx].created_at.to_s)
        end
      end
    end
  end

  describe '画面の表示内容を変更する' do
    before { visit_after_login(user: user, visit_path: admin_user_tasks_path(user)) }

    describe 'ソート順を変更する' do
      context '新着順でソートしたい場合' do
        it 'created_atの降順で表示されていること' do
          tasks = Task.order(created_at: :desc).limit(10)
          click_sort_pulldown('created_at')
          all('table#task_table tbody tr').each.with_index do |td, idx|
            expect(td).to have_content(tasks[idx].created_at.to_s)
          end
          expect(page.find('#search_sort', visible: false).value).to eq 'created_at'
        end
      end

      context '期日が近い順でソートしたい場合' do
        it 'deadlineの昇順で表示されていること' do
          tasks = Task.order(deadline: :asc).limit(10)
          click_sort_pulldown('deadline')
          all('table#task_table tbody tr').each.with_index do |td, idx|
            expect(td).to have_content(tasks[idx].deadline.to_s)
          end
          expect(page.find('#search_sort', visible: false).value).to eq 'deadline'
        end
      end

      context '優先度が高い順でソートしたい場合' do
        it 'priorityの降順で表示されていること' do
          tasks = Task.order(priority: :desc).limit(10)
          click_sort_pulldown('priority')
          all('table#task_table tbody tr').each.with_index do |td, idx|
            expect(td).to have_content(Task.human_attribute_name("priorities.#{tasks[idx].priority}"))
          end
          expect(page.find('#search_sort', visible: false).value).to eq 'priority'
        end
      end
    end

    describe '一覧を絞り込む' do
      let(:target) { Task.first }

      context 'タイトルで絞り込みたい場合' do
        before { title_search(target.title) }

        it '入力値に完全に一致するタスクのみ表示されていること' do
          expect(page).to have_css('table#task_table tbody tr', count: 1)
          expect(first('table#task_table tbody tr')).to have_content(target.title)
        end

        it '入力したタイトルが検索後の画面で表示されていること' do
          expect(page.find('#search_title', visible: false).value).to eq target.title
        end
      end

      context 'ステータスで絞り込みたい場合' do
        before do
          find(:css, '.fa-search').click
          within('#search_modal .modal-body') { select Task.human_attribute_name('statuses.done'), from: 'search_status' }
          click_on I18n.t('helpers.submit.search')
        end

        it '選択したステータスに完全に一致するタスクのみ表示されていること' do
          expect(page).to have_css('table#task_table tbody tr', count: 2)
          all('table#task_table tbody tr').each do |td|
            expect(td).to have_content(Task.human_attribute_name('statuses.done'))
          end
        end

        it '入力したステータスが検索後の画面で表示されていること' do
          expect(page.find('#search_status', visible: false).value).to eq 'done'
        end
      end

      context 'ステータスで絞り込まない場合' do
        before do
          find(:css, '.fa-search').click
          within('#search_modal .modal-body') { select '', from: 'search_status' }
          click_on I18n.t('helpers.submit.search')
        end

        it '空白行を選択した場合、絞り込みが行われず全てのタスクが表示されていること' do
          expect(page).to have_css('table#task_table tbody tr', count: 10)
        end
      end

      context 'タイトルとステータスで絞り込みたい場合' do
        before do
          find(:css, '.fa-search').click
          within('#search_modal .modal-body') do
            fill_in I18n.t('page.task.labels.title'), with: target.title
            select Task.human_attribute_name("statuses.#{target.status}"), from: 'search_status'
          end
          click_on I18n.t('helpers.submit.search')
        end

        it '選択したタイトルとステータスに完全に一致するタスクのみ表示されていること' do
          expect(page).to have_css('table#task_table tbody tr', count: 1)
          expect(first('table#task_table tbody tr')).to have_content(target.title)
          expect(first('table#task_table tbody tr')).to have_content(Task.human_attribute_name("statuses.#{target.status}"))
        end
      end
    end
  end
end

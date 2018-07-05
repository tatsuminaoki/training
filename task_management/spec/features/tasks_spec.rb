require 'rails_helper'

RSpec.feature "Tasks", type: :feature do
  background do
    @task = create(:task)
  end

  feature '画面遷移' do
    context '一覧画面で「新規作成」をクリックする' do
      scenario 'タスク登録画面に遷移する' do
        visit root_path
        click_on I18n.t('button.new')

        expect(current_path).to eq tasks_new_path
        expect(page).to have_field 'task_task_name'
        expect(page).to have_field 'task_description'
        expect(page).to have_field 'task_due_date'
        expect(page).to have_select 'task_status'
        expect(page).to have_select 'task_priority'
        expect(page).to have_button I18n.t('helpers.submit.create')
      end
    end

    context '一覧画面でタスク名をクリックする' do
      scenario 'タスク詳細画面に遷移する' do
        visit root_path
        click_on I18n.t('view.task_name', :task => @task.task_name)

        expect(current_path).to eq show_task_path(@task.id)
        expect(page).not_to have_content I18n.t('flash.success_update')
        expect(page).to have_content I18n.t('button.home')
        expect(page).to have_content I18n.t('button.edit')
        expect(page).to have_content I18n.t('button.delete')
        expect(page).to have_content I18n.t('view.task_name', :task => @task.task_name)
        expect(page).to have_content I18n.t('view.description', :task => @task.description)
        expect(page).to have_content I18n.t('view.due_date', :task => @task.due_date)
        expect(page).to have_content I18n.t('view.status', :task => I18n.t("status.#{@task.status}"))
        expect(page).to have_content I18n.t('view.priority', :task => I18n.t("priority.#{@task.priority}"))
      end
    end

    context 'タスク詳細画面で「一覧」をクリックする' do
      scenario '一覧画面に遷移する' do
        visit show_task_path(@task.id)
        click_on I18n.t('button.home')

        expect(current_path).to eq root_path
        expect(page).not_to have_content I18n.t('flash.success_create')
        expect(page).not_to have_content I18n.t('flash.success_delete', :task => @task.task_name)
        expect(page).to have_content I18n.t('button.new')
        expect(page).to have_content I18n.t('sort.default')
        expect(page).to have_content I18n.t('sort.due_date.desc')
        expect(page).to have_content I18n.t('sort.priority.desc')
        expect(page).to have_field 'searched_task_name'
        expect(page).to have_unchecked_field I18n.t('status.todo')
        expect(page).to have_unchecked_field I18n.t('status.doing')
        expect(page).to have_unchecked_field I18n.t('status.done')
        expect(page).to have_button I18n.t('helpers.submit.search')
        expect(page).to have_content '1件'
        expect(page).to have_content I18n.t('view.task_name', :task => @task.task_name)
        expect(page).to have_content I18n.t('view.due_date', :task => @task.due_date)
        expect(page).to have_content I18n.t('view.status', :task => I18n.t("status.#{@task.status}"))
        expect(page).to have_content I18n.t('view.priority', :task => I18n.t("priority.#{@task.priority}"))
      end
    end

    context 'タスク詳細画面で「編集」をクリックする' do
      scenario 'タスク編集画面に遷移する' do
        visit show_task_path(@task.id)
        click_on I18n.t('button.edit')
        
        expect(current_path).to eq edit_task_path(@task.id)
        expect(page).to have_field 'task_task_name', with: @task.task_name
        expect(page).to have_field 'task_description', with: @task.description
        expect(page).to have_field 'task_due_date', with: @task.due_date
        expect(page).to have_select 'task_status', selected: I18n.t("status.#{@task.status}")
        expect(page).to have_select 'task_priority', selected: I18n.t("priority.#{@task.priority}")
        expect(page).to have_button I18n.t('helpers.submit.update')
      end
    end

    context 'ソート済みの一覧画面で「元の順番に戻す」をクリックする' do
      given(:uri) {URI.parse(current_url)}
      scenario 'クエリパラメータ無しで一覧画面に遷移する' do
        visit root_path(sort: 'due_date_asc')
        click_on I18n.t('sort.default')

        expect(uri.path).to eq root_path
        expect(uri.query).to eq nil
      end
    end
  end

  feature 'タスクの登録' do
    context '想定される値を入力してタスクを登録する' do
      scenario '登録に成功する' do
        visit tasks_new_path
        fill_in 'task_task_name', with: "#{@task.task_name}"
        fill_in 'task_description', with: "#{@task.description}"
        fill_in 'task_due_date', with: "#{@task.due_date}"
        select I18n.t('status.todo'), from: 'task_status'
        select I18n.t('priority.low'), from: 'task_priority'
        click_button I18n.t('helpers.submit.create')
        
        expect(current_path).to eq root_path
        expect(page).to have_content I18n.t('flash.success_create')
        expect(page).to have_content I18n.t('view.task_name', :task => @task.task_name)
        expect(page).to have_content I18n.t('view.due_date', :task => @task.due_date)
        expect(page).to have_content I18n.t('view.status', :task => I18n.t("status.#{@task.status}"))
        expect(page).to have_content I18n.t('view.priority', :task => I18n.t("priority.#{@task.priority}"))
      end
    end

    context '0文字のタスクを登録する' do
      scenario '登録に失敗してエラーメッセージが表示される' do
        visit tasks_new_path
        fill_in 'task_task_name', with: ''
        fill_in 'task_description', with: "#{@task.description}"
        fill_in 'task_due_date', with: "#{@task.due_date}"
        click_button I18n.t('helpers.submit.create')
        
        expect(current_path).to eq tasks_path
        expect(page).to have_content 'タスク名を入力してください。'
      end
    end

    context '256文字のタスクを登録する' do
      scenario '登録に失敗してエラーメッセージが表示される' do
        visit tasks_new_path
        fill_in 'task_task_name', with: 'a'*256
        fill_in 'task_description', with: "#{@task.description}"
        fill_in 'task_due_date', with: "#{@task.due_date}"
        click_button I18n.t('helpers.submit.create')
        
        expect(current_path).to eq tasks_path
        expect(page).to have_content 'タスク名は255字以内で入力してください。'
      end
    end

    context '存在しない日付を登録する' do
      scenario '登録に失敗してエラーメッセージが表示される' do
        visit tasks_new_path
        fill_in 'task_task_name', with: "#{@task.task_name}"
        fill_in 'task_description', with: "#{@task.description}"
        fill_in 'task_due_date', with: '2018-06-31'
        click_button I18n.t('helpers.submit.create')
        
        expect(current_path).to eq tasks_path
        expect(page).to have_content '期限を正しく入力してください。'
      end
    end

    context 'タスク名が0文字かつ存在しない日付を登録する' do
      scenario '登録に失敗してエラーメッセージが表示される' do
        visit tasks_new_path
        fill_in 'task_task_name', with: ''
        fill_in 'task_description', with: "#{@task.description}"
        fill_in 'task_due_date', with: '2018-06-31'
        click_button I18n.t('helpers.submit.create')
        
        expect(current_path).to eq tasks_path
        expect(page).to have_content 'タスク名を入力してください。' 
        expect(page).to have_content '期限を正しく入力してください。'
      end
    end

    context 'ステータスを空白文字で登録する', js: true do
      scenario '登録に失敗してエラーメッセージが表示される' do
        visit tasks_new_path
        fill_in 'task_task_name', with: "#{@task.task_name}"
        select I18n.t('status.todo'), from: 'task_status'
        page.execute_script("$(\"[name='task[status]'] option:selected\").val('');")
        click_button I18n.t('helpers.submit.create')

        expect(current_path).to eq tasks_path
        expect(page).to have_content '状態を入力してください。' 
      end
    end

    context '優先度を空白文字で登録する', js: true do
      scenario '登録に失敗してエラーメッセージが表示される' do
        visit tasks_new_path
        fill_in 'task_task_name', with: "#{@task.task_name}"
        select I18n.t('priority.low'), from: 'task_priority'
        page.execute_script("$(\"[name='task[priority]'] option:selected\").val('');")
        click_button I18n.t('helpers.submit.create')

        expect(current_path).to eq tasks_path
        expect(page).to have_content '優先度を入力してください。' 
      end
    end
  end

  feature 'タスクの更新' do
    context '想定される値を入力してタスクを更新する' do
      scenario '更新に成功する' do
        visit edit_task_path(@task.id)
        fill_in 'task_task_name', with: "#{@task.task_name}(edited)"
        fill_in 'task_description', with: "#{@task.description}(edited)"
        fill_in 'task_due_date', with: "#{(@task.due_date + 1).to_s}"
        select I18n.t('status.doing'), from: 'task_status'
        select I18n.t('priority.high'), from: 'task_priority'
        click_button I18n.t('helpers.submit.update')

        expect(current_path).to eq show_task_path(@task.id)
        expect(page).to have_content I18n.t('flash.success_update')
        expect(page).to have_content I18n.t('view.task_name', :task => @task.task_name + '(edited)')
        expect(page).to have_content I18n.t('view.description', :task => @task.description + '(edited)')
        expect(page).to have_content I18n.t('view.due_date', :task => (@task.due_date + 1).to_s)
        expect(page).to have_content I18n.t('view.status', :task => I18n.t('status.doing'))
        expect(page).to have_content I18n.t('view.priority', :task => I18n.t('priority.high'))
      end
    end

    context '0文字のタスクに更新する' do
      scenario '更新に失敗してエラーメッセージが表示される' do
        visit edit_task_path(@task.id)
        fill_in 'task_task_name', with: ''
        fill_in 'task_description', with: "#{@task.description}(edited)"
        fill_in 'task_due_date', with: "#{(@task.due_date + 1).to_s}"
        click_button I18n.t('helpers.submit.update')

        expect(current_path).to eq edit_task_path(@task.id)
        expect(page).to have_content 'タスク名を入力してください。'
      end
    end

    context '256文字のタスクに更新する' do
      scenario '更新に失敗してエラーメッセージが表示される' do
        visit edit_task_path(@task.id)
        fill_in 'task_task_name', with: 'a'*256
        fill_in 'task_description', with: "#{@task.description}(edited)"
        fill_in 'task_due_date', with: "#{(@task.due_date + 1).to_s}"
        click_button I18n.t('helpers.submit.update')

        expect(current_path).to eq edit_task_path(@task.id)
        expect(page).to have_content 'タスク名は255字以内で入力してください。'
      end
    end

    context '存在しない日付に更新する' do
      scenario '更新に失敗してエラーメッセージが表示される' do
        visit edit_task_path(@task.id)
        fill_in 'task_task_name', with: "#{@task.task_name}(edited)"
        fill_in 'task_description', with: "#{@task.description}(edited)"
        fill_in 'task_due_date', with: '2018-06-31'
        click_button I18n.t('helpers.submit.update')

        expect(current_path).to eq edit_task_path(@task.id)
        expect(page).to have_content '期限を正しく入力してください。'
      end
    end

    context 'タスク名が256文字かつ存在しない日付に更新する' do
      scenario '更新に失敗してエラーメッセージが表示される' do
        visit edit_task_path(@task.id)
        fill_in 'task_task_name', with: 'a'*256
        fill_in 'task_description', with: "#{@task.description}(edited)"
        fill_in 'task_due_date', with: '2018-06-31'
        click_button I18n.t('helpers.submit.update')

        expect(current_path).to eq edit_task_path(@task.id)
        expect(page).to have_content 'タスク名は255字以内で入力してください。' 
        expect(page).to have_content '期限を正しく入力してください。'
      end
    end

    context 'ステータスを空白文字で更新する', js: true do
      scenario '更新に失敗してエラーメッセージが表示される' do
        visit edit_task_path(@task.id)
        fill_in 'task_task_name', with: "#{@task.task_name}"
        select I18n.t('status.todo'), from: 'task_status'
        page.execute_script("$(\"[name='task[status]'] option:selected\").val('');")
        click_button I18n.t('helpers.submit.update')

        expect(current_path).to eq edit_task_path(@task.id)
        expect(page).to have_content '状態を入力してください。' 
      end
    end

    context '優先度を空白文字で更新する', js: true do
      scenario '更新に失敗してエラーメッセージが表示される' do
        visit edit_task_path(@task.id)
        fill_in 'task_task_name', with: "#{@task.task_name}"
        select I18n.t('priority.low'), from: 'task_priority'
        page.execute_script("$(\"[name='task[priority]'] option:selected\").val('');")
        click_button I18n.t('helpers.submit.update')

        expect(current_path).to eq edit_task_path(@task.id)
        expect(page).to have_content '優先度を入力してください。' 
      end
    end
  end

  feature 'タスクの削除' do
    context 'タスクを削除する' do
      scenario '削除に成功する' do
        visit show_task_path(@task.id)
        click_on I18n.t('button.delete')
        
        expect(current_path).to eq root_path
        expect(page).to have_content I18n.t('flash.success_delete', :task => @task.task_name)
        visit current_path
        expect(page).not_to have_content I18n.t('view.task_name', :task => @task.task_name)
      end
    end
  end

  feature 'ソート' do
    background do
      %w(high low middle).each do |priority|
        Timecop.travel(Time.now + 1.day)
        create(:task, priority: priority)
      end
      Timecop.return
    end

    context 'クエリパラメータ無しで一覧画面にアクセスする' do
      given(:ordered_tasks) {prepare_ordered_tasks('created_at DESC')}
      given(:tasks_list) {all('ul li')}

      scenario 'タスクが作成日の降順で表示される' do
        visit root_path
        
        tasks_list.each_with_index do |t, i|
          expect(t.text).to eq ordered_tasks[i]
        end
        expect(page).to have_content I18n.t('sort.due_date.desc')
        expect(page).to have_content I18n.t('sort.priority.desc')
      end
    end

    context '「期限▲」をクリックする' do
      given(:ordered_tasks) {prepare_ordered_tasks('due_date ASC')}
      given(:tasks_list) {all('ul li')}
      given(:uri) {uri = URI.parse(current_url)}

      scenario 'タスクが期限の昇順で表示される' do
        visit root_path(sort: 'due_date_desc')
        click_on I18n.t('sort.due_date.asc')

        tasks_list.each_with_index do |t, i|
          expect(t.text).to eq ordered_tasks[i]
        end
        expect("#{uri.path}?#{uri.query}").to eq root_path(sort: 'due_date_asc')
        expect(page).to have_content I18n.t('sort.due_date.desc')
        expect(page).to have_content I18n.t('sort.priority.desc')
      end
    end

    context '「期限▼」をクリックする' do
      given(:ordered_tasks) {prepare_ordered_tasks('due_date DESC')}
      given(:tasks_list) {all('ul li')}
      given(:uri) {uri = URI.parse(current_url)}

      scenario 'タスクが期限の降順で表示される' do
        visit root_path(sort: 'due_date_asc')
        click_on I18n.t('sort.due_date.desc')

        tasks_list.each_with_index do |t, i|
          expect(t.text).to eq ordered_tasks[i]
        end
        expect("#{uri.path}?#{uri.query}").to eq root_path(sort: 'due_date_desc')
        expect(page).to have_content I18n.t('sort.due_date.asc')
        expect(page).to have_content I18n.t('sort.priority.desc')
      end
    end

    context '「優先度▲」をクリックする' do
      given(:ordered_tasks) {prepare_ordered_tasks('priority ASC')}
      given(:tasks_list) {all('ul li')}
      given(:uri) {uri = URI.parse(current_url)}

      scenario 'タスクが優先度の昇順で表示される' do
        visit root_path(sort: 'priority_desc')
        click_on I18n.t('sort.priority.asc')

        tasks_list.each_with_index do |t, i|
          expect(t.text).to eq ordered_tasks[i]
        end
        expect("#{uri.path}?#{uri.query}").to eq root_path(sort: 'priority_asc')
        expect(page).to have_content I18n.t('sort.due_date.desc')
        expect(page).to have_content I18n.t('sort.priority.desc')
      end
    end

    context '「優先度▼」をクリックする' do
      given(:ordered_tasks) {prepare_ordered_tasks('priority DESC')}
      given(:tasks_list) {all('ul li')}
      given(:uri) {uri = URI.parse(current_url)}

      scenario 'タスクが優先度の降順で表示される' do
        visit root_path
        click_on I18n.t('sort.priority.desc')

        tasks_list.each_with_index do |t, i|
          expect(t.text).to eq ordered_tasks[i]
        end
        expect("#{uri.path}?#{uri.query}").to eq root_path(sort: 'priority_desc')
        expect(page).to have_content I18n.t('sort.due_date.desc')
        expect(page).to have_content I18n.t('sort.priority.asc')
      end
    end
  end

  feature '検索' do
    background do
      create(:task, task_name: 'a', status: 'todo')
      create(:task, task_name: 'a', status: 'doing')
      create(:task, task_name: 'a', status: 'done')
      create(:task, task_name: 'b', status: 'todo')
      create(:task, task_name: '0%', status: 'todo')
    end

    context '検索結果が存在する' do
      given(:uri) {uri = URI.parse(current_url)}

      scenario '検索結果が表示される' do
        visit root_path
        fill_in 'searched_task_name', with: 'a'
        check I18n.t('status.todo')
        click_button I18n.t('helpers.submit.search')
      
        expect(uri.path).to eq root_path
        expect(uri.query).to have_content 'searched_task_name=a'
        expect(uri.query).to have_content 'statuses[]=todo'
        expect(page).to have_content '2件'
        expect(page).to have_field 'searched_task_name', with: 'a'
        expect(page).to have_checked_field I18n.t('status.todo')
        expect(page).to have_unchecked_field I18n.t('status.doing')
        expect(page).to have_unchecked_field I18n.t('status.done')
        expect(page).to have_content I18n.t('view.task_name', :task => @task.task_name)
        expect(page).to have_content I18n.t('view.task_name', :task => 'a')
        expect(page).not_to have_content I18n.t('view.task_name', :task => 'b')
        expect(page).to have_content I18n.t('view.status', :task => I18n.t("status.todo"))
        expect(page).not_to have_content I18n.t('view.status', :task => I18n.t("status.doing"))
        expect(page).not_to have_content I18n.t('view.status', :task => I18n.t("status.done"))
      end
    end

    context '「%」を入力して検索する' do
      scenario 'ワイルドカードが無効化されている' do
        visit root_path
        fill_in 'searched_task_name', with: '%'
        check I18n.t('status.todo')
        click_button I18n.t('helpers.submit.search')
              
        expect(page).not_to have_content 'a'
        expect(page).to have_content '0%'
      end   
    end
  end
end

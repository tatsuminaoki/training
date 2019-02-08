require 'rails_helper'

feature 'タスク管理機能', type: :feature do
  let(:user_a) { create(:user, name: 'ユーザーA') }
  let!(:task_a) { create(:task, :first_task, user: user_a) }
  let!(:task_b) { create(:task, :second_task, user: user_a) }
  let!(:task_c) { create(:task, :third_task, user: user_a) }

  describe '一覧表示機能' do
    context '一覧表示画面へ遷移した時' do
      background do
        login
        visit tasks_path
      end

      scenario 'タスクは作成日付の降順で表示される' do
        task_a_index = page.body.index('最初のタスク')
        task_b_index = page.body.index('2つ目のタスク')
        task_c_index = page.body.index('3つ目のタスク')

        # indexが大きいとリストの後ろ側に表示されているとみなす
        expect(task_c_index).to be < task_b_index
        expect(task_b_index).to be < task_a_index
      end
    end

    context '終了期限を昇順でソートした時' do
      background do
        login
        visit tasks_path
        click_link '完了期限'
        # 昇順にするためには2度押す
        click_link '完了期限'
      end

      scenario 'タスクは作成日付の降順で表示される' do
        task_a_index = page.body.index('最初のタスク')
        task_b_index = page.body.index('2つ目のタスク')
        task_c_index = page.body.index('3つ目のタスク')

        # indexが大きいとリストの後ろ側に表示されているとみなす
        expect(task_c_index).to be < task_a_index
        expect(task_a_index).to be < task_b_index
      end
    end

    context '終了期限を降順でソートした時' do
      background do
        login
        visit tasks_path
        click_link '完了期限'
      end

      scenario 'タスクは作成日付の降順で表示される' do
        task_a_index = page.body.index('最初のタスク')
        task_b_index = page.body.index('2つ目のタスク')
        task_c_index = page.body.index('3つ目のタスク')

        # indexが大きいとリストの後ろ側に表示されているとみなす
        expect(task_b_index).to be < task_a_index
        expect(task_a_index).to be < task_c_index
      end
    end

    context 'タイトルとステータスで検索した時' do
      background do
        login
        visit tasks_path

        fill_in :q_title_cont, with: 'つ目のタスク'
        select '着手中', from: :q_status_eq

        click_button '検索'
      end

      scenario '絞り込まれたやつだけ表示される' do
        task_a_index = page.body.index('最初のタスク')
        task_b_index = page.body.index('2つ目のタスク')
        task_c_index = page.body.index('3つ目のタスク')

        expect(task_a_index).to be nil
        expect(task_b_index).to be nil
        expect(task_c_index).not_to be nil
      end
    end

    context 'タイトルで検索した時' do
      background do
        login
        visit tasks_path

        fill_in :q_title_cont, with: 'つ目のタスク'

        click_button '検索'
      end

      scenario '絞り込まれたやつだけ表示される' do
        task_a_index = page.body.index('最初のタスク')
        task_b_index = page.body.index('2つ目のタスク')
        task_c_index = page.body.index('3つ目のタスク')

        expect(task_a_index).to be nil
        expect(task_b_index).not_to be nil
        expect(task_c_index).not_to be nil
      end
    end

    context 'ステータスで検索した時' do
      background do
        login
        visit tasks_path

        select '完了', from: :q_status_eq

        click_button '検索'
      end

      scenario '絞り込まれたやつだけ表示される' do
        task_a_index = page.body.index('最初のタスク')
        task_b_index = page.body.index('2つ目のタスク')
        task_c_index = page.body.index('3つ目のタスク')

        expect(task_a_index).to be nil
        expect(task_b_index).not_to be nil
        expect(task_c_index).to be nil
      end
    end

    context '検索＆終了期限を昇順でソートした時' do
      background do
        login
        visit tasks_path

        select '着手中', from: :q_status_eq

        click_button '検索'

        click_link '完了期限'
        # 昇順にするためには2度押す
        click_link '完了期限'
      end

      scenario '絞り込まれた状態でソートされる' do
        task_a_index = page.body.index('最初のタスク')
        task_b_index = page.body.index('2つ目のタスク')
        task_c_index = page.body.index('3つ目のタスク')

        expect(task_b_index).to be nil
        expect(task_c_index).to be < task_a_index
      end
    end

    context '検索＆終了期限を降順でソートした時' do
      background do
        login
        visit tasks_path

        select '着手中', from: :q_status_eq

        click_button '検索'

        click_link '完了期限'
      end

      scenario '絞り込まれた状態でソートされる' do
        task_a_index = page.body.index('最初のタスク')
        task_b_index = page.body.index('2つ目のタスク')
        task_c_index = page.body.index('3つ目のタスク')

        expect(task_b_index).to be nil
        expect(task_a_index).to be < task_c_index
      end
    end

    context 'タスク数が8件の時' do
      background do
        login
        # タスクを5個追加で作る（既に3つ作ってるので合計8個）
        5.times do |i|
          create(:task, user: user_a)
        end

        visit tasks_path
      end

      scenario '8件が表示される' do
        # ヘッダ部分もtrなので、+1
        expect(all('tr').size).to eq(9)
      end
    end

    context 'タスク数が9件の時' do
      background do
        login
        # タスクを6個追加で作る（既に3つ作ってるので合計9個）
        6.times do |i|
          create(:task, user: user_a)
        end

        visit tasks_path
      end

      scenario '最初ページでは8件が表示される' do
        # ヘッダ部分もtrなので、+1
        expect(all('tr').size).to eq(9)
      end

      scenario '次のページでは1件が表示される' do
        find_link('次').click
        # ヘッダ部分もtrなので、+1
        expect(all('tr').size).to eq(2)
      end
    end
  end
end

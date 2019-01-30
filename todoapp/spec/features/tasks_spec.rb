require 'rails_helper'

feature 'タスク管理機能', type: :feature do
  let(:user_a) { create(:user, name: 'ユーザーA') }
  let!(:task_a) {
    create(:task,
           title: '最初のタスク',
           user: user_a,
           status: 'working',
           end_at: '2100-10-10 00:10:00',
           created_at: '2010-10-10 00:10:00')
  }
  let!(:task_b) {
    create(:task,
           title: '2つ目のタスク',
           user: user_a,
           status: 'completed',
           end_at: '2100-10-10 00:10:01',
           created_at: '2010-10-10 00:10:01')
  }
  let!(:task_c) {
    create(:task,
           title: '3つ目のタスク',
           user: user_a,
           status: 'working',
           end_at: nil,
           created_at: '2010-10-10 00:10:02')
  }

  shared_examples_for 'ユーザーAが作成したタスクが表示される' do
    scenario { expect(page).to have_content '最初のタスク' }
  end

  describe '一覧表示機能' do
    context '一覧表示画面へ遷移した時' do
      background do
        visit tasks_path
      end

      it_behaves_like 'ユーザーAが作成したタスクが表示される'

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
        # タスクを6個追加で作る（既に3つ作ってるので合計9個）
        6.times do |i|
          create(:task, user: user_a)
        end

        visit tasks_path
      end

      scenario '8件が表示される' do
        # ヘッダ部分もtrなので、+1
        expect(all('tr').size).to eq(9)
      end
    end
  end

  describe '詳細表示機能' do
    context '詳細表示画面へ遷移した時' do
      background do
        visit task_path(task_a)
      end

      it_behaves_like 'ユーザーAが作成したタスクが表示される'
    end
  end

  describe '新規作成機能' do
    background do
      visit new_task_path

      # タスクのフォーム入力
      fill_in :task_title, with: 'たすくだよ'
      fill_in :task_description, with: 'たすくのせつめいだよ'
      fill_in :task_end_at, with: '2100-01-01'

      # フォームの内容をチェック
      expect(page).to have_field :task_title, with: 'たすくだよ'
      expect(page).to have_field :task_description, with: 'たすくのせつめいだよ'
      expect(page).to have_field :task_end_at, with: '2100-01-01'

      # 作成
      click_button '登録する'
    end

    context '規作成画面で正しい情報を入力した時' do
      scenario '登録後の画面で内容が正常に表示される' do
        expect(page).to have_content 'たすくだよ'
        expect(page).to have_content 'たすくのせつめいだよ'
        expect(page).to have_content '2100/01/01 00:00:00'
      end
    end
  end
end

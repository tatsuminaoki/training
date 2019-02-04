# frozen_string_literal: true

require 'rails_helper'

feature 'タスク管理機能', type: :feature do
  feature '一覧機能' do
    let!(:first_task) { FactoryBot.create(:task) }

    scenario '初期レコードが確認できる' do
      visit root_path
      expect(page).to have_no_selector '.alert-success'
      expect(page).to have_content '掃除'
      expect(page).to have_content '02/25'
      expect(page).to have_content '中'
      expect(page).to have_content '着手中'
      expect(Task.count).to eq 1
    end
  end

  feature 'ソート機能' do
    let!(:tasks) {
      [
        FactoryBot.create(
          :task,
          name:       'タスク1',
          due_date:   '20190203',
          priority:   Task.priorities[:middle],
          status:     Task.statuses[:in_progress],
          created_at: Time.zone.now,
        ),
        FactoryBot.create(
          :task,
          name:       'タスク2',
          due_date:   '20190209',
          priority:   Task.priorities[:high],
          status:     Task.statuses[:done],
          created_at: 1.day.ago,
        ),
        FactoryBot.create(
          :task,
          name:       'タスク3',
          due_date:   '20190206',
          priority:   Task.priorities[:low],
          status:     Task.statuses[:to_do],
          created_at: 2.days.ago,
        ),
      ]
    }

    shared_examples_for '任意の順でソートされる' do |options = {}|
      scenario '並び順が一致する' do
        visit root_path

        if options[:sort_column].present? && options[:direction].present?
          page.find('th', text: options[:sort_column]).click_link(options[:direction])
          sleep 1
        end

        table_elements = page.all('tbody tr').map(&:text)
        table_elements.shift

        3.times do |i|
          expect(table_elements[i]).to have_content(tasks[options[:order][i]].name)
        end
      end
    end

    context '一覧画面で何もしないとき' do
      it_behaves_like '任意の順でソートされる', { order: [0, 1, 2] }
    end

    context '列「登録日時」の「▲/▼」をクリックした時' do
      it_behaves_like '任意の順でソートされる', { sort_column: '登録日時', direction: '▲', order: [2, 1, 0] }
      it_behaves_like '任意の順でソートされる', { sort_column: '登録日時', direction: '▼', order: [0, 1, 2] }
    end

    context '列「優先度」の「▲/▼」をクリックした時' do
      it_behaves_like '任意の順でソートされる', { sort_column: '優先度', direction: '▲', order: [2, 0, 1] }
      it_behaves_like '任意の順でソートされる', { sort_column: '優先度', direction: '▼', order: [1, 0, 2] }
    end

    context '列「期限」の「▲/▼」をクリックした時' do
      it_behaves_like '任意の順でソートされる', { sort_column: '期限', direction: '▲', order: [0, 2, 1] }
      it_behaves_like '任意の順でソートされる', { sort_column: '期限', direction: '▼', order: [1, 2, 0] }
    end
  end

  feature '検索機能' do
    let!(:tasks) {
      [
        FactoryBot.create(
          :task,
          name:       'タスク1',
          due_date:   '20190203',
          priority:   Task.priorities[:middle],
          status:     Task.statuses[:in_progress],
          created_at: Time.zone.now,
        ),
        FactoryBot.create(
          :task,
          name:       'タスク2',
          due_date:   '20190209',
          priority:   Task.priorities[:high],
          status:     Task.statuses[:to_do],
          created_at: 1.day.ago,
        ),
        FactoryBot.create(
          :task,
          name:       'task3',
          due_date:   '20190206',
          priority:   Task.priorities[:low],
          status:     Task.statuses[:in_progress],
          created_at: 2.days.ago,
        ),
        FactoryBot.create(
          :task,
          name:       'ラスク4',
          due_date:   '20190212',
          priority:   Task.priorities[:low],
          status:     Task.statuses[:in_progress],
          created_at: 3.days.ago,
        ),
      ]
    }

    before do
      visit root_path
      fill_in 'name', with: task_name
      select status, from: 'status'
      click_on('検索')
    end

    context '「タスク」で名前検索したとき' do
      let(:task_name) { 'タスク' }
      let(:status) { '指定しない' }

      scenario '検索結果は2件' do
        expect(page.all('tr').size).to eq 3
        expect(page).to have_content('タスク1', count: 1)
        expect(page).to have_content('タスク2', count: 1)
        expect(find_field('name').value).to eq 'タスク'
      end
    end

    context '「hoge」で名前検索したとき' do
      let(:task_name) { 'hoge' }
      let(:status) { '指定しない' }

      scenario '検索結果は0件' do
        expect(page.all('tr').size).to eq 1
        expect(find_field('name').value).to eq 'hoge'
      end
    end

    context '「着手中」でステータス検索したとき' do
      let(:task_name) { '' }
      let(:status) { '着手中' }

      scenario '検索結果は3件' do
        expect(page.all('tr').size).to eq 4
        expect(page).to have_content('タスク1', count: 1)
        expect(page).to have_content('task3', count: 1)
        expect(page).to have_content('ラスク4', count: 1)
        expect(page).to have_select('status', selected: '着手中')
      end
    end

    context '「指定しない」でステータス検索したとき' do
      let(:task_name) { '' }
      let(:status) { '指定しない' }

      scenario '検索結果は4件' do
        expect(page.all('tr').size).to eq 5
        expect(page).to have_select('status', selected: '指定しない')
      end
    end

    context '名前&ステータス検索したとき' do
      let(:task_name) { 'スク' }
      let(:status) { '着手中' }

      scenario '検索結果は2件' do
        expect(page.all('tr').size).to eq 3
        expect(page).to have_content('タスク1', count: 1)
        expect(page).to have_content('ラスク4', count: 1)
        expect(find_field('name').value).to eq 'スク'
        expect(page).to have_select('status', selected: '着手中')
      end
    end

    context '検索後、期限で降順ソートしたとき' do
      let(:task_name) { 'スク' }
      let(:status) { '着手中' }

      before do
        page.find('th', text: '期限').click_link('▼')
        sleep 1
      end

      scenario '検索結果2件が期限で降順ソートされる' do
        expect(page.all('tr').size).to eq 3
        expect(page.all('tr')[1].text).to have_content 'ラスク4'
        expect(page.all('tr')[2].text).to have_content 'タスク1'
        expect(find_field('name').value).to eq 'スク'
        expect(page).to have_select('status', selected: '着手中')
      end
    end

    context '検索後、優先度で昇順ソートしたとき' do
      let(:task_name) { 'スク' }
      let(:status) { '着手中' }

      before do
        page.find('th', text: '優先度').click_link('▲')
        sleep 1
      end

      scenario '検索結果2件が優先度で昇順ソートされる' do
        expect(page.all('tr').size).to eq 3
        expect(page.all('tr')[1].text).to have_content 'ラスク4'
        expect(page.all('tr')[2].text).to have_content 'タスク1'
        expect(find_field('name').value).to eq 'スク'
        expect(page).to have_select('status', selected: '着手中')
      end
    end
  end

  feature 'ページネーション機能' do
    let!(:tasks) { 10.times { FactoryBot.create(:task) } }

    before { visit root_path }

    context 'タスク件数が10件のとき' do
      scenario '1ページ目に6件表示される' do
        expect(page).to have_content '全10件中1 - 6件のタスクが表示されています'
        expect(page).to have_link '次 ›'
        expect(page).to have_no_link '‹ 前'
        expect(page.all('tr').size).to eq 7 # 1番目のtrはヘッダの為、レコード件数+1
      end

      scenario '2ページ目に4件表示される' do
        find_link('次').click
        expect(page).to have_content '全10件中7 - 10件のタスクが表示されています'
        expect(page).to have_link '‹ 前'
        expect(page).to have_no_link '次 ›'
        expect(page.all('tr').size).to eq 5 # 1番目のtrはヘッダの為、レコード件数+1
      end
    end
  end

  feature '登録・編集機能' do
    shared_examples_for '正常処理とバリデーションエラーの確認' do |action, name, description|
      before do
        visit root_path

        case action
        when :create
          page.find('#navbarDropdownMenuLink').click
          page.click_link('タスク登録')
        when :update
          click_on('編集')
        end

        fill_in 'タスク名', with: task_name
        fill_in '説明', with: task_description
        fill_in '期限', with: '20190213'
        select '高', from: 'task_priority'
        select '着手中', from: 'task_status'
        click_on('送信')
      end

      context '正常値を入力したとき' do
        let(:task_name) { name }
        let(:task_description) { description }

        scenario '正常に処理される' do
          expect(page).to have_selector '.alert-success'
          expect(page).to have_content name
          expect(page).to have_content '02/13'
          expect(page).to have_content '高'
          expect(page).to have_content '着手中'
          expect(Task.count).to eq 1
        end
      end

      context '制限内の文字数を入力したとき' do
        let(:task_name) { 'a' * 30 }
        let(:task_description) { 'a' * 800 }

        scenario '正常に処理される' do
          expect(page).to have_no_selector '#error_explanation'
          expect(page).to have_selector '.alert-success'
        end
      end

      context '空欄のまま送信したとき' do
        let(:task_name) { '' }
        let(:task_description) { '' }

        scenario '入力を促すエラーメッセージが表示される' do
          expect(page).to have_selector '#error_explanation', text: 'タスク名を入力してください'
          expect(page).to have_selector '#error_explanation', text: '説明を入力してください'
        end
      end

      context '制限外の文字数を入力したとき' do
        let(:task_name) { 'a' * 31 }
        let(:task_description) { 'a' * 801 }

        scenario '文字数に関するエラーメッセージが表示される' do
          expect(page).to have_selector '#error_explanation', text: '30文字以内'
          expect(page).to have_selector '#error_explanation', text: '800文字以内'
        end
      end
    end

    feature '登録' do
      it_behaves_like '正常処理とバリデーションエラーの確認', :create, '最初のタスク', '最初のタスクの説明'
    end

    feature '編集' do
      let!(:first_task) { FactoryBot.create(:task) }
      it_behaves_like '正常処理とバリデーションエラーの確認', :update, '掃除', 'トイレ,風呂,キッチン'
    end
  end

  feature '削除機能' do
    let!(:first_task) { FactoryBot.create(:task) }

    before do
      visit root_path
      click_on('削除')
    end

    context '確認ダイアログのOKを押したとき' do
      scenario '正常に削除される' do
        page.driver.browser.switch_to.alert.accept
        expect(page).to have_selector '.alert-success', text: 'タスク「掃除」を削除しました。'
        expect(Task.count).to eq 0
      end
    end
  end
end

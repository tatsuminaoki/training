# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'Tasks', type: :feature do
  # ログイン状態の作成
  background do
    user = create(:user, id: 1)
    visit root_path
    fill_in 'メールアドレス', with: user.email
    fill_in 'パスワード', with: user.password
    click_button 'ログイン'
  end
  let(:user) { User.find(1) }

  scenario '新しいタスクを作成する' do
    expect do
      click_link '新規タスク登録', match: :first
      fill_in 'タスク名', with: '勉強'
      click_button '登録する'
      expect(page).to have_content 'タスクを作成しました'
      expect(page).to have_content '勉強'
    end.to change { Task.count }.by(1)
  end

  scenario 'タスクを編集する' do
    click_link '新規タスク登録', match: :first
    fill_in 'タスク名', with: '勉強'
    click_button '登録する'
    expect do
      find('.edit-btn').click
      fill_in 'タスク名', with: '運動'
      click_button '更新する'
      expect(page).to have_content 'タスクを編集しました'
      expect(page).to have_content '運動'
    end.to change { Task.count }.by(0)
  end

  scenario 'タスクを削除する' do
    click_link '新規タスク登録', match: :first
    fill_in 'タスク名', with: '勉強'
    click_button '登録する'
    expect do
      find('.delete-btn').click
      expect(page).to have_content 'タスクを削除しました'
    end.to change { Task.count }.by(-1)
  end

  feature 'タスクの並び順' do
    background do
      create(:task, name: 'タスク１', created_at: '2018-7-16 08:10:10', user_id: user.id)
      create(:task, name: 'タスク２', created_at: '2018-7-16 09:10:15', user_id: user.id)
    end
    scenario 'タスク一覧が作成日時の降順で並んでいること' do
      visit root_path
      names = page.all('td.name')
      expect(names[0]).to have_content 'タスク２'
      expect(names[1]).to have_content 'タスク１'
    end
  end

  feature '終了期限でのソート機能' do
    background do
      create(:task, name: '終了期限先', deadline: '2018-7-18', created_at: '2018-7-16 08:10:10', user_id: user.id)
      create(:task, name: '終了期限後', deadline: '2018-7-25', created_at: '2018-7-16 09:10:15', user_id: user.id)
    end
    scenario 'タスク一覧画面で終了期限でソートできること' do
      # 「終了期限後」を後に作成したので上に表示されている
      visit root_path
      names = page.all('td.name')
      expect(names[0]).to have_content '終了期限後'
      expect(names[1]).to have_content '終了期限先'
      # 終了期限をクリックすると終了期限が早い順にソートされ、「終了期限先」が上に表示される
      click_link '終了期限'
      names = page.all('td.name')
      expect(names[0]).to have_content '終了期限先'
      expect(names[1]).to have_content '終了期限後'
      # もう一度終了期限をクリックすると反対に終了期限が遅い順にソートされ、「終了期限後」が上に表示される
      click_link '終了期限'
      names = page.all('td.name')
      expect(names[0]).to have_content '終了期限後'
      expect(names[1]).to have_content '終了期限先'
    end
  end

  feature '検索機能' do
    background do
      create(:task, name: 'タスク１', status: 'to_do', user_id: user.id)
      create(:task, name: 'タスク２', status: 'doing', user_id: user.id)
    end
    scenario 'タスク一覧画面で検索結果が表示されていること' do
      visit root_path
      fill_in 'タスク名', with: 'タスク１'
      select '未着手', from: 'search_status'
      click_button '検索'
      expect(page).to have_content 'タスク１'
      expect(page).not_to have_content 'タスク２'
    end
  end

  feature '優先度でのソート機能' do
    background do
      create(:task, name: '優先度中タスク', priority: 'middle', created_at: '2018-7-20 16:55:10', user_id: user.id)
      create(:task, name: '優先度高タスク', priority: 'high', created_at: '2018-7-20 16:58:14', user_id: user.id)
      create(:task, name: '優先度低タスク', priority: 'low', created_at: '2018-7-20 17:01:34', user_id: user.id)
    end
    scenario 'タスク一覧画面で優先度でソートできること' do
      visit root_path
      # created_atの降順で並んでいることの確認
      names = page.all('td.name')
      expect(names[0]).to have_content '優先度低タスク'
      expect(names[1]).to have_content '優先度高タスク'
      expect(names[2]).to have_content '優先度中タスク'
      click_link '優先度'
      # 優先度ボタンをクリックすると優先度の高い順でソートされていることの確認
      names = page.all('td.name')
      expect(names[0]).to have_content '優先度高タスク'
      expect(names[1]).to have_content '優先度中タスク'
      expect(names[2]).to have_content '優先度低タスク'
      click_link '優先度'
      # もう一度優先度ボタンをクリックすると優先度の低い順でソートされていることの確認
      names = page.all('td.name')
      expect(names[0]).to have_content '優先度低タスク'
      expect(names[1]).to have_content '優先度中タスク'
      expect(names[2]).to have_content '優先度高タスク'
    end
  end

  feature 'ページネーション' do
    background do
      create_list(:task, 11, user_id: user.id)
    end
    scenario 'タスク一覧画面で10件ずつのページネーションとなっていること' do
      visit root_path
      names = page.all('td.name')
      # 10件目は表示されており、11件目は表示されていないことの確認
      expect(names.count).to eq 10
      click_link '次'
      names = page.all('td.name')
      # 2ページ目に11件目が表示されていることの確認
      expect(names.count).to eq 1
    end
  end

  feature 'ユーザー毎のタスク表示' do
    background do
      create(:task, name: 'タスク１', user_id: user.id)
      create(:user, id: 2, email: 'raku2@example.com')
    end
    scenario '自分が作成したタスクのみ表示する' do
      click_link 'ログアウト'
      # 別ユーザーでログイン
      fill_in 'メールアドレス', with: 'raku2@example.com'
      fill_in 'パスワード', with: 'password'
      click_button 'ログイン'
      create(:task, name: 'タスク２', user_id: 2)
      visit root_path
      # ログイン中のユーザのタスク（タスク２）のみが表示されていることの確認
      expect(page).to have_content 'タスク２'
      expect(page).not_to have_content 'タスク１'
    end
  end

  feature 'ラベル関連' do
    scenario '複数のラベルをつけてタスクを作成する' do
      expect do
        expect do
          expect do
            click_link '新規タスク登録', match: :first
            fill_in 'タスク名', with: '勉強'
            fill_in 'ラベル', with: 'study,english'
            click_button '登録する'
          end.to change { Task.count }.by(1)
        end.to change { Label.count }.by(2)
      end.to change { TaskLabel.count }.by(2)
    end

    scenario 'バリデーションにかかった時に値を保持する' do
      click_link '新規タスク登録', match: :first
      fill_in 'タスク名', with: 'a' * 30
      fill_in 'ラベル', with: 'study,english'
      click_button '登録する'
      expect(page).to have_field 'ラベル', with: 'study,english'
    end

    feature 'ラベルが重複して作成されない' do
      background do
        click_link '新規タスク登録', match: :first
        fill_in 'タスク名', with: 'task1'
        fill_in 'ラベル', with: 'label1,label2'
        click_button '登録する'
      end

      scenario '同じラベルを登録した場合' do
        expect do
          expect do
            click_link '新規タスク登録', match: :first
            fill_in 'タスク名', with: 'task2'
            fill_in 'ラベル', with: 'label1'
            click_button '登録する'
          end.to change { TaskLabel.count }.by(1)
        end.to change { Label.count }.by(0)
      end
    end

    scenario '同じラベルを同時に登録した場合ラベルが重複して作成されない' do
      expect do
        expect do
          click_link '新規タスク登録', match: :first
          fill_in 'タスク名', with: 'task1'
          fill_in 'ラベル', with: 'label1,label1'
          click_button '登録する'
        end.to change { TaskLabel.count }.by(1)
      end.to change { Label.count }.by(1)
    end

    feature 'ラベルの編集機能' do
      background do
        click_link '新規タスク登録', match: :first
        fill_in 'タスク名', with: '勉強'
        fill_in '内容', with: 'TOEIC800'
        select '着手', from: 'ステータス'
        select '中', from: '優先度'
        fill_in '終了期限', with: '08/11/2018'
        fill_in 'ラベル', with: 'study,english'
        click_button '登録する'
      end

      scenario '編集画面で値が保持されていること' do
        find('.edit-btn').click
        expect(page).to have_field 'タスク名', with: '勉強'
        expect(page).to have_field '内容', with: 'TOEIC800'
        expect(page).to have_select('ステータス', selected: '着手')
        expect(page).to have_select('優先度', selected: '中')
        # expect(page).to have_field '終了期限', with: '08/11/2018'
        expect(page).to have_field 'ラベル', with: 'study,english'
      end

      scenario 'ラベルを「study,english」→「english」に編集したパターン' do
        expect do
          expect do
            find('.edit-btn').click
            fill_in 'ラベル', with: 'english'
            click_button '更新する'
          end.to change { TaskLabel.count }.by(-1)
        end.to change { Label.count }.by(-1)
      end

      scenario 'ラベルを「study,english」→「english,study」に編集したパターン' do
        expect do
          expect do
            find('.edit-btn').click
            fill_in 'ラベル', with: 'english,study'
            click_button '更新する'
          end.to change { TaskLabel.count }.by(0)
        end.to change { Label.count }.by(0)
      end

      scenario 'ラベルを「study,english」→「」に編集したパターン' do
        expect do
          expect do
            find('.edit-btn').click
            fill_in 'ラベル', with: ''
            click_button '更新する'
          end.to change { TaskLabel.count }.by(-2)
        end.to change { Label.count }.by(-2)
      end

      scenario 'ラベルをつけたタスクの削除' do
        expect do
          expect do
            find('.delete-btn').click
          end.to change { TaskLabel.count }.by(-2)
        end.to change { Label.count }.by(-2)
      end

      scenario '他タスクに同じラベルがある場合のタスクの削除' do
        click_link '新規タスク登録', match: :first
        fill_in 'タスク名', with: '勉強②'
        fill_in 'ラベル', with: 'study,japanese'
        click_button '登録する'
        expect do
          expect do
            expect do
              all('.delete-btn')[0].click
            end.to change { Task.count }.by(-1)
          end.to change { TaskLabel.count }.by(-2)
        end.to change { Label.count }.by(-1)
      end
    end

    feature 'ラベルの検索機能' do
      background do
        click_link '新規タスク登録', match: :first
        fill_in 'タスク名', with: '勉強'
        fill_in 'ラベル', with: 'study'
        click_button '登録する'
        click_link '新規タスク登録', match: :first
        fill_in 'タスク名', with: '運動'
        fill_in 'ラベル', with: 'workout'
        click_button '登録する'
      end

      scenario '検索ができる' do
        select 'study', from: 'search_label'
        click_button '検索'
        labels = page.all('td.name')
        expect(labels.count).to have_content 1
      end

      scenario '検索条件がフォームに保持されていること' do
        fill_in 'タスク名', with: 'tasktask'
        select '未着手', from: 'search_status'
        select 'study', from: 'search_label'
        click_button '検索'
        expect(page).to have_field 'タスク名', with: 'tasktask'
        expect(page).to have_select('ステータス', selected: '未着手')
        expect(page).to have_select('ラベル', selected: 'study')
      end

      scenario '同じラベルを登録した際に検索のセレクトボックスに重複して表示されない' do
        click_link '新規タスク登録', match: :first
        fill_in 'タスク名', with: '勉強②'
        fill_in 'ラベル', with: 'study'
        click_button '登録する'
        labels = page.all('option').map(&:text)
        expect(labels.count('study')).to eq 1
      end
    end
  end

  feature '複数ユーザでのラベル操作' do
    background do
      click_link '新規タスク登録', match: :first
      fill_in 'タスク名', with: 'task1'
      fill_in 'ラベル', with: 'label1,label2'
      click_button '登録する'
      click_link 'ログアウト'
      user2 = create(:user, id: 2)
      fill_in 'メールアドレス', with: user2.email
      fill_in 'パスワード', with: user2.password
      click_button 'ログイン'
      click_link '新規タスク登録', match: :first
      fill_in 'タスク名', with: 'task2'
      fill_in 'ラベル', with: 'label1'
      click_button '登録する'
    end

    scenario '別ユーザが同じラベルを登録していて、一方がラベルを削除できる' do
      expect do
        expect do
          find('.edit-btn').click
          fill_in 'ラベル', with: ''
          click_button '更新する'
        end.to change { TaskLabel.count }.by(-1)
      end.to change { Label.count }.by(0)
    end
  end
end

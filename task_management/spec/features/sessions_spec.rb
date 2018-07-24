require 'rails_helper'

RSpec.feature "Sessions", type: :feature do
  background do
    @user = create(:user)
    @task = create(:task, user_id: @user.id)
  end
  
  feature '認証' do
    context 'ログインに成功した場合' do
      background do
        login(@user.mail_address, @user.password)
      end

      scenario '一覧画面に遷移して、必要な情報を表示する' do
        expect(current_path).to eq root_path
        expect(page).to have_content 'ログインに成功しました'
        expect(page).to have_button @user.user_name
      end
    end

    context 'ログインに失敗した場合' do
      context 'DBにユーザが存在しない場合' do
        scenario 'エラーメッセージが表示される' do
          login('unregistered_mail_address', 'unregistered_password')

          expect(current_path).to eq login_path
          expect(page).to have_content 'ログインに失敗しました'
        end
      end

      context 'メールアドレスを間違えた場合' do
        scenario 'エラーメッセージが表示される' do
          login('missed_mail_address', @user.password)

          expect(current_path).to eq login_path
          expect(page).to have_content 'ログインに失敗しました'
        end
      end

      context 'パスワードを間違えた場合' do
        scenario 'エラーメッセージが表示される' do
          login(@user.mail_address, 'missed_password')

          expect(current_path).to eq login_path
          expect(page).to have_content 'ログインに失敗しました'
        end
      end

      context 'メールアドレスを入力しない場合' do
        scenario 'エラーメッセージが表示される' do
          login(nil, @user.password)

          expect(current_path).to eq login_path
          expect(page).to have_content 'ログインに失敗しました'
        end
      end

      context 'パスワードを入力しない場合' do
        scenario 'エラーメッセージが表示される' do
          login(@user.mail_address, nil)

          expect(current_path).to eq login_path
          expect(page).to have_content 'ログインに失敗しました'
        end
      end
    end

    context 'ログイン済みの場合' do
      background do
        login(@user.mail_address, @user.password)
      end

      scenario 'ログイン画面にアクセスすると一覧画面にリダイレクトされる' do
        visit login_path
        expect(current_path).to eq root_path
      end
    end

    context 'ログアウト' do
      background do
        login(@user.mail_address, @user.password)
      end

      scenario 'ログイン画面に遷移する' do
        logout

        expect(current_path).to eq login_path
        expect(page).to have_content 'ログアウトしました'
      end

      scenario '一覧画面に遷移できない' do
        logout
        visit root_path

        expect(current_path).to eq login_path
        expect(page).to have_content 'ログインしてください'
      end
    end
  end

  feature '認可' do
    given(:task) {create(:task, task_name: 'a', user_id: @user.id)}
    given(:user2) {create(:user, user_name: 'b', mail_address: 'b@example.com', password: 'b')}
    
    context '一覧画面' do
      given!(:task2) {create(:task, task_name: 'b', user_id: user2.id)}
      scenario 'ログインしたユーザが作成したタスクのみ見えること' do
        login(user2.mail_address, user2.password)

        expect(page).to have_content "タスク：#{task2.task_name}"
        expect(page).not_to have_content "タスク：#{task.task_name}"
      end

      scenario 'ログインしていないときにログイン画面にリダイレクトされること' do
        visit root_path

        expect(current_path).to eq login_path
        expect(page).to have_content 'ログインしてください'
      end
    end

    context '検索' do
      background do
        5.times do |i|
          create(:task, task_name: "a_#{i}", user_id: @user.id)
        end
      end
      given!(:task2) {create(:task, task_name: 'b', user_id: user2.id)}

      scenario 'ログインしたユーザが作成したタスクのみ見えること' do
        login(user2.mail_address, user2.password)
        click_button I18n.t('helpers.submit.search')

        expect(page).to have_content "タスク：#{task2.task_name}"
        expect(page).not_to have_content "タスク：#{task.task_name}"
      end
    end

    context '詳細画面' do
      scenario 'ログインしたユーザが作成したタスクにアクセスできること' do
        login(@user.mail_address, @user.password)
        visit show_task_path(task.id)

        expect(current_path).to eq show_task_path(task.id)
      end

      scenario 'ログインしたユーザ以外が作成したタスクにアクセスできないこと' do
        login(user2.mail_address, user2.password)
        visit show_task_path(task.id)

        expect(current_path).to eq root_path
        expect(page).to have_content '無効なタスクにアクセスしました'
      end

      scenario 'ログインしていないときにログイン画面にリダイレクトされること' do
        visit show_task_path(task.id)

        expect(current_path).to eq login_path
        expect(page).to have_content 'ログインしてください'
      end
    end

    context '編集画面' do
      scenario 'ログインしたユーザが作成したタスクにアクセスできること' do
        login(@user.mail_address, @user.password)
        visit edit_task_path(task.id)

        expect(current_path).to eq edit_task_path(task.id)
      end

      scenario 'ログインしたユーザ以外が作成したタスクにアクセスできないこと' do
        login(user2.mail_address, user2.password)
        visit edit_task_path(task.id)

        expect(current_path).to eq root_path
        expect(page).to have_content '無効なタスクにアクセスしました'        
      end

      scenario 'ログインしていないときにログイン画面にリダイレクトされること' do
        visit edit_task_path(task.id)

        expect(current_path).to eq login_path
        expect(page).to have_content 'ログインしてください'
      end
    end
  end
end

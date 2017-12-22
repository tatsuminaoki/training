require 'rails_helper'

RSpec.describe LoginsController, type: :controller do

  shared_examples_for 'post_create_test' do
    it 'エラーメッセージを表示して、ログイン画面を再表示する' do
      post :login, params: params
      expect(session[:user_id]).to be_nil
      expect(response).to render_template :new
    end
  end

  describe 'GET #new' do
    context 'ログインしている場合' do
      before { set_user_session }

      it 'タスク一覧ページに移動する' do
        get :new
        expect(response).to redirect_to(root_path)
      end
    end

    context 'ログインしていない場合' do
      it 'ログイン画面が表示される' do
        get :new
        expect(response).to render_template :new
      end
    end
  end

  describe 'POST #login' do
    let(:user) { FactoryBot.create(:user) }

    context '入力された値が正しい場合' do
      let(:params) { {email: user.email, password: user.password} }

      it 'ログインして、タスク一覧ページに移動する' do
        post :login, params: params
        expect(session[:user_id]).to eq user.id
        expect(response).to redirect_to(root_path)
      end
    end

    context '入力された値が正しく無い場合' do
      context 'メールアドレスが空欄の場合' do
        let(:params) { {email: '', password: user.password} }
        it_behaves_like 'post_create_test'
      end

      context 'メールアドレスが一致しない場合' do
        let(:params) { {email: 'hogehoge', password: user.password} }
        it_behaves_like 'post_create_test'
      end

      context 'パスワードが空欄の場合' do
        let(:params) { {email: user.email, password: ''} }
        it_behaves_like 'post_create_test'
      end

      context 'パスワードが一致しない場合' do
        let(:params) { {email: user.email, password: 'hogehoge'} }
        it_behaves_like 'post_create_test'
      end

      context '両方とも空欄の場合' do
        let(:params) { {email: '', password: ''} }
        it_behaves_like 'post_create_test'
      end

      context '両方とも一致しない場合' do
        let(:params) { {email: 'hogehoge', password: 'hogehoge'} }
        it_behaves_like 'post_create_test'
      end
    end
  end

  describe 'DELETE #logout' do
    context 'ログインしている場合' do
      before { set_user_session }

      it 'ログアウトして、ログイン画面が表示される' do
        delete :logout
        expect(session[:user_id]).to be_nil
        expect(response).to redirect_to(logins_new_path)
      end
    end

    context 'ログインしていない場合' do
      it 'ログイン画面が表示される' do
        delete :logout
        expect(response).to redirect_to(logins_new_path)
      end
    end
  end
end

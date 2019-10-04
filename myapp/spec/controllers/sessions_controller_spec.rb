# frozen_string_literal: true

describe SessionsController, type: :request do
  describe 'POST #create' do
    let!(:user) { FactoryBot.create :user }

    context '正常なパラメーターの場合' do
      it 'ROOTへリダイレクトされること' do
        post login_path, params: { login_id: user.login_id, password: 'TestPassword123' }
        expect(response).to have_http_status :found
        expect(response).to redirect_to root_url
      end
    end

    context '誤ったパラメーターの場合' do
      it '誤ったパスワードならログインが失敗すること' do
        post login_path, params: { login_id: 'TestUser1', password: 'hoge' }
        expect(response).to have_http_status :unauthorized
        expect(response.body).to include 'ログインに失敗しました'
      end

      it '空白ならログインが失敗すること' do
        post login_path, params: { login_id: '', password: '' }
        expect(response).to have_http_status :unauthorized
        expect(response.body).to include 'ログインIDとパスワードは必須入力です'
      end
    end
  end

  describe 'DELETE #destroy' do
    let(:user) { FactoryBot.create :user }
    before do
      post login_path, params: { login_id: user.login_id, password: 'TestPassword123' }
    end

    context '正常なパラメーターの場合' do
      it 'ログイン画面へリダイレクトされること' do
        delete logout_url
        expect(response).to have_http_status :found
        expect(response).to redirect_to login_url
      end
    end
  end
end

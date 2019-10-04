# frozen_string_literal: true

describe SessionsController, type: :request do
  describe 'GET #index' do
    let!(:user) { FactoryBot.create :user }

    context '正常なパラメーターの場合' do
      it 'ROOTへリダイレクトされること' do
        post login_path, params: { login_id: user.login_id, password: 'TestPassword' }
        expect(response).to have_http_status :found
        expect(response).to redirect_to root_url
      end
    end

    context '誤ったパラメーターの場合' do
      it 'ログインが失敗すること' do
        post login_path, params: { login_id: 'TestUser1', password: 'hoge' }
        expect(response).to have_http_status :ok
        expect(response.body).to include 'ログインに失敗しました'
      end
    end
  end
end

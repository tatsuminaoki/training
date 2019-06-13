# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UserCredentialsController, type: :controller do
  describe "GET #new" do
    let(:user_token) { create(:user_token) }

    it "returns http success" do
      get :new, params: { id: user_token.token }

      expect(response).to be_successful
      expect(response).to render_template('user_credentials/new')
    end

    context "存在しないトークン" do
      it "returns not found" do
        get :new, params: { id: 'hogehogefugafuga' }

        expect(response).to have_http_status(:not_found)
        # expect {
        #   get :new, params: { id: 'hogehogefugafuga' }
        # }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    context "期限切れのトークン" do
      before do
        user_token.update!(expires_at: 1.day.ago)
      end

      it "returns forbidden" do
        get :new, params: { id: user_token.token }

        expect(response).to have_http_status(:forbidden)
      end
    end
  end

  describe "POST #create" do
    let(:user_token) { create(:user_token) }
    let(:params) do
      {
        id: user_token.token,
        user_credential: {
          password: "password",
          password_confirmation: "password",
        },
      }
    end

    it "パスワード設定できること" do
      post :create, params: params

      expect(response).to be_successful
      expect(response).to render_template('user_credentials/create')
      expect(UserCredential.count).to eq(1)
    end

    context "異なるパスワードで" do
      before do
        params[:user_credential][:password_confirmation] = "hoge"
      end

      it "パスワード設定できないこと" do
        post :create, params: params

        expect(response).to be_successful
        expect(response).to render_template('user_credentials/new')
        expect(assigns(:user_credential).errors[:password_confirmation]).to be_present
        expect(UserCredential.count).to eq(0)
      end
    end
  end
end

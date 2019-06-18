# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  describe 'GET #new' do
    it 'returns http success' do
      get :new

      expect(response).to be_successful
      expect(response).to render_template('users/new')
    end
  end

  describe 'POST #create' do
    let(:params) do
      {
        user: {
          name: 'name',
          email: 'test@test.com',
          email_confirmation: 'test@test.com',
        },
      }
    end

    before do
      ActionMailer::Base.deliveries.clear
    end

    it 'ユーザー作成できること' do
      post :create, params: params

      expect(response).to be_successful
      expect(response).to render_template('users/create')
      expect(User.count).to eq(1)

      sendmail = ActionMailer::Base.deliveries.find { |mail| mail.to == ['test@test.com'] }
      expect(sendmail.decode_body).to include('パスワード設定のURLを送信しました。')
    end

    context 'メールアドレス形式が正しくない' do
      before do
        params[:user][:email] = 'test@test'
        params[:user][:email_confirmation] = 'test@test'
      end

      it 'ユーザー作成できないこと' do
        post :create, params: params

        expect(response).to be_successful
        expect(response).to render_template('users/new')
        expect(assigns(:user).errors[:email]).to be_present
        expect(User.count).to eq(0)
      end
    end

    context '異なるメールアドレスで' do
      before do
        params[:user][:email_confirmation] = 'hoge@test.com'
      end

      it 'ユーザー作成できないこと' do
        post :create, params: params

        expect(response).to be_successful
        expect(response).to render_template('users/new')
        expect(assigns(:user).errors[:email_confirmation]).to be_present
        expect(User.count).to eq(0)
      end
    end
  end
end

# frozen_string_literal: true

require 'rails_helper'

describe Admin::UsersController do
  render_views

  describe 'GET #index' do
    let(:admin_user) { create(:user, role: :admin) }
    let(:normal_user) { create(:user, role: :normal) }

    context '管理ユーザーでログイン' do
      before do
        session[:user_id] = admin_user.id
      end

      it '管理者だったら、ユーザー一覧にアクセスできる' do
        get :index
        expect(response.status).to eq 200
      end
    end

    context '一般ユーザーでログイン' do
      before do
        session[:user_id] = normal_user.id
      end

      it '一般ユーザーだったら、ユーザー一覧にアクセスできない' do
        get :index
        expect(response.status).to redirect_to(tasks_path)
      end
    end
  end
end

require 'rails_helper'

RSpec.describe Admin::UsersController, type: :controller do
  render_views

  describe 'GET index new edit' do
    before(:each) do
      # @u = User.find_or_create_by(email: 'test@example.com')
      @u = User.create!(name: 'John', email: 'test@example.com', roles: 'admin', password: 'mypassword')
    end

    context 'when user is logged' do
      before(:each) do
        session[:user_id] = @u.id
      end

      it 'get index' do
        get :index
        expect(response.status).to eq(200)
      end

      it 'get new' do
        get :new
        expect(response.status).to eq(200)
        expect(response).to render_template('new')
      end

      it 'get edit' do
        get :edit, params: { id: @u.id }
        expect(response.status).to eq(200)
        expect(response).to render_template('edit')
      end
    end
  end

  describe 'POST create' do
    let(:params) do
      {
        user: {
          name: 'mary',
          email: 'test2@example.com',
          password: 'mypassword2',
          password_confirmation: 'mypassword2'
        },
      }
    end
    before(:each) do
      @u = User.create!(name: 'John', email: 'test@example.com', roles: 'admin', password: 'mypassword')
    end

    context 'when user is logged' do
      before(:each) do
        session[:user_id] = @u.id
      end

      it 'can create user' do
        post :create, params: params
        expect(response.status).to eq(302)
        expect(response.status).to redirect_to(root_path)
        expect(User.count).to eq(2)
      end
    end
  end

  describe 'PATCH update' do
    before(:each) do
      @u = User.create!(name: 'John', email: 'test@example.com', roles: 'admin', password: 'mypassword')
    end
    let(:params) do
      {
        id: @u.id,
        user: {
          name: 'Corner',
          email: 'test@example.com',
          password: 'mypassword',
          password_confirmation: 'mypassword'
        },
      }
    end

    context 'when user is logged' do
      before(:each) do
        session[:user_id] = @u.id
      end

      it 'can update user' do
        patch :update, params: params
        expect(response.status).to eq(302)
        expect(response.status).to redirect_to(admin_user_path)
      end
    end
  end

  describe 'DELETE destroy' do
    before(:each) do
      @u1 = User.create!(name: 'John', email: 'test@example.com', roles: 'admin', password: 'mypassword')
      @u2 = User.create!(name: 'Mary', email: 'test2@example.com', roles: 'user', password: 'mypassword2')
    end

    context 'when user is logged' do
      before(:each) do
        session[:user_id] = @u1.id
      end

      it 'can delete user' do
        delete :destroy, params: { id: @u2.id }
        expect(response.status).to eq(302)
        expect(response.status).to redirect_to(admin_users_path)
        expect(User.count).to eq(1)
      end
    end
  end

end

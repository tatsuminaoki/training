# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Admin::UsersController, type: :controller do
  before do
    log_in user
  end
  # This should return the minimal set of attributes required to create a valid
  # User. As you add validations to User, be sure to
  # adjust the attributes here as well.
  let(:user) { create(:admin_user) }
  let(:general_user) { create(:user) }

  let(:valid_attributes) {
    {
      name: 'user name',
      role: '1',
      password: 'password',
      password_digest: User.digest('password'),
    }
  }

  let(:invalid_attributes) {
    {
      name: '',
    }
  }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # UsersController. Be sure to keep this updated too.
  let(:valid_session) {
    {
      name: user.name,
      password: 'password',
      password_digest: User.digest('password'),
    }
  }

  describe 'GET #index' do
    after do
      # Get rid of the maintenance file
      FileUtils.rm_rf(Dir[Rails.root.join('public', 'tmp', 'maintenance')]) if Rails.env.test?
    end

    it 'returns a success response' do
      User.create! valid_attributes
      get :index, params: {}, session: valid_session
      expect(response).to be_successful
    end

    it 'redirect to root path as general user' do
      log_in general_user
      get :index, params: {}, session: valid_session
      expect(response).to redirect_to(root_path)
    end

    it 'render the 503 page' do
      MaintenanceMode.start
      get :index, params: {}, session: valid_session
      expect(response).to render_template('errors/maintenance')
    end
  end

  describe 'GET #new' do
    after do
      # Get rid of the maintenance file
      FileUtils.rm_rf(Dir[Rails.root.join('public', 'tmp', 'maintenance')]) if Rails.env.test?
    end

    it 'returns a success response' do
      get :new, params: {}, session: valid_session
      expect(response).to be_successful
    end

    it 'redirect to root path as general user' do
      log_in general_user
      get :new, params: {}, session: valid_session
      expect(response).to redirect_to(root_path)
    end

    it 'render the 503 page' do
      MaintenanceMode.start
      get :new, params: {}, session: valid_session
      expect(response).to render_template('errors/maintenance')
    end
  end

  describe 'GET #edit' do
    after do
      # Get rid of the maintenance file
      FileUtils.rm_rf(Dir[Rails.root.join('public', 'tmp', 'maintenance')]) if Rails.env.test?
    end

    it 'returns a success response' do
      user = User.create! valid_attributes
      get :edit, params: { id: user.to_param }, session: valid_session
      expect(response).to be_successful
    end

    it 'redirect to root path as general user' do
      log_in general_user
      user = User.create! valid_attributes
      get :edit, params: { id: user.to_param }, session: valid_session
      expect(response).to redirect_to(root_path)
    end

    it 'render the 503 page' do
      MaintenanceMode.start
      user = User.create! valid_attributes
      get :edit, params: { id: user.to_param }, session: valid_session
      get :new, params: {}, session: valid_session
      expect(response).to render_template('errors/maintenance')
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new User' do
        expect {
          post :create, params: { user: valid_attributes }, session: valid_session
        }.to change(User, :count).by(1)
      end

      it 'redirects to the created user' do
        post :create, params: { user: valid_attributes }, session: valid_session
        expect(response).to redirect_to(admin_users_path)
      end

      it 'redirect to root path as general user' do
        log_in general_user
        post :create, params: { user: valid_attributes }, session: valid_session
        expect(response).to redirect_to(root_path)
      end
    end

    context 'with invalid params' do
      it "returns a success response (i.e. to display the 'new' template)" do
        post :create, params: { user: invalid_attributes }, session: valid_session
        expect(response).to be_successful
      end
    end
  end

  describe 'PUT #update' do
    context 'with valid params' do
      let(:new_attributes) {
        { name: 'new user name', password: 'password', password_digest: User.digest('password') }
      }

      it 'updates the requested user' do
        user = User.create! valid_attributes
        put :update, params: { id: user.to_param, user: new_attributes }, session: valid_session
        expect { user.reload }.to(
          change(user, :name).from('user name').to('new user name'),
        )
      end

      it 'redirects to the user' do
        user = User.create! valid_attributes
        put :update, params: { id: user.to_param, user: valid_attributes }, session: valid_session
        expect(response).to redirect_to(admin_users_path)
      end

      it 'redirect to root path as general user' do
        log_in general_user
        user = User.create! valid_attributes
        put :update, params: { id: user.to_param, user: valid_attributes }, session: valid_session
        expect(response).to redirect_to(root_path)
      end

      it 'keep admin user role for last one' do
        user.role = 'general'
        user.valid?
        expect(user.errors[:base][0]).to include('少なくとも1人の管理者が必要です')
      end
    end

    context 'with invalid params' do
      it "returns a success response (i.e. to display the 'edit' template)" do
        user = User.create! valid_attributes
        put :update, params: { id: user.to_param, user: invalid_attributes }, session: valid_session
        expect(response).to be_successful
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the requested user' do
      user = User.create! valid_attributes
      expect {
        delete :destroy, params: { id: user.to_param }, session: valid_session
      }.to change(User, :count).by(-1)
    end

    it 'redirects to the users list' do
      user = User.create! valid_attributes
      delete :destroy, params: { id: user.to_param }, session: valid_session
      expect(response).to redirect_to(admin_users_path)
    end

    it 'redirect to root path as general user' do
      log_in general_user
      user = User.create! valid_attributes
      delete :destroy, params: { id: user.to_param }, session: valid_session
      expect(response).to redirect_to(root_path)
    end

    it 'keep last admin user' do
      expect {
        delete :destroy, params: { id: user.to_param }, session: valid_session
      }.to change(User, :count).by(0)
    end
  end
end

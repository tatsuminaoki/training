# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  before do
    log_in user
  end
  # This should return the minimal set of attributes required to create a valid
  # User. As you add validations to User, be sure to
  # adjust the attributes here as well.
  let(:user) { create(:user) }
  let(:other_user) { create(:other_user) }
  let(:admin_user) { create(:admin_user) }

  let(:valid_attributes) {
    {
      name: 'user name',
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
  let(:valid_session) { {} }

  describe 'GET #show' do
    context 'by correct user' do
      it 'returns a success response' do
        get :show, params: { id: user.to_param }, session: valid_session
        expect(response).to render_template(:show)
      end
    end
    context 'by not correct user' do
      it 'redirect to root page' do
        log_in other_user
        get :show, params: { id: user.to_param }, session: valid_session
        expect(response).to redirect_to(:root)
      end
    end

    it 'render the 503 page' do
      SwitchMaintenanceMode.new.exec
      get :show, params: { id: user.to_param }, session: valid_session
      expect(response).to render_template(file: "#{Rails.root}/public/503.html")
    end
  end

  describe 'GET #new' do
    context 'by correct user' do
      it 'returns a success response' do
        get :new, params: {}, session: valid_session
        expect(response).to render_template(:new)
      end
    end
    context 'by not correct user' do
      it 'returns a success response' do
        log_in other_user
        get :new, params: {}, session: valid_session
        expect(response).to render_template(:new)
      end
    end

    it 'render the 503 page' do
      SwitchMaintenanceMode.new.exec
      get :new, params: {}, session: valid_session
      expect(response).to render_template(file: "#{Rails.root}/public/503.html")
    end
  end

  describe 'GET #edit' do
    context 'by correct user' do
      it 'returns a success response' do
        get :edit, params: { id: user.to_param }, session: valid_session
        expect(response).to render_template(:edit)
      end
    end
    context 'by not correct user' do
      it 'redirect to root path' do
        log_in other_user
        get :edit, params: { id: user.to_param }, session: valid_session
        expect(response).to redirect_to(:root)
      end
    end

    it 'render the 503 page' do
      SwitchMaintenanceMode.new.exec
      get :edit, params: { id: user.to_param }, session: valid_session
      expect(response).to render_template(file: "#{Rails.root}/public/503.html")
    end
  end

  describe 'POST #create' do
    context 'by correct user' do
      context 'with valid params' do
        it 'creates a new User' do
          expect {
            post :create, params: { user: valid_attributes }, session: valid_session
          }.to change(User, :count).by(1)
        end
        it 'redirects to the created user' do
          post :create, params: { user: valid_attributes }, session: valid_session
          expect(response).to redirect_to(root_path)
        end
      end

      context 'with invalid params' do
        it "returns a success response (i.e. to display the 'new' template)" do
          post :create, params: { user: invalid_attributes }, session: valid_session
          expect(response).to render_template(:new)
        end
      end
    end

    context 'by not correct user' do
      context 'with valid params' do
        it 'creates a new User' do
          log_in other_user
          expect {
            post :create, params: { user: valid_attributes }, session: valid_session
          }.to change(User, :count).by(1)
        end
        it 'redirects to the created user' do
          log_in other_user
          post :create, params: { user: valid_attributes }, session: valid_session
          expect(response).to redirect_to(root_path)
        end
      end

      context 'with invalid params' do
        it "returns a success response (i.e. to display the 'new' template)" do
          log_in other_user
          post :create, params: { user: invalid_attributes }, session: valid_session
          expect(response).to render_template(:new)
        end
      end
    end
  end

  describe 'PUT #update' do
    context 'by correct user' do
      context 'with valid params' do
        let(:new_attributes) {
          { name: 'new user name', password: 'password', password_digest: User.digest('password') }
        }

        it 'updates the requested user' do
          put :update, params: { id: user.to_param, user: new_attributes }, session: valid_session
          expect { user.reload }.to(
            change(user, :name).from('test name').to('new user name'),
          )
        end

        it 'redirects to the user' do
          put :update, params: { id: user.to_param, user: valid_attributes }, session: valid_session
          expect(response).to redirect_to(user)
        end
      end

      context 'with invalid params' do
        it "returns a success response (i.e. to display the 'edit' template)" do
          put :update, params: { id: user.to_param, user: invalid_attributes }, session: valid_session
          expect(response).to be_successful
        end
      end
    end
    context 'by not correct user' do
      context 'with valid params' do
        let(:new_attributes) {
          { name: 'new user name', password: 'password', password_digest: User.digest('password') }
        }

        it 'redirects to root path' do
          log_in other_user
          put :update, params: { id: user.to_param, user: valid_attributes }, session: valid_session
          expect(response).to redirect_to(:root)
        end
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'by correct user' do
      it 'destroys the requested user' do
        expect {
          delete :destroy, params: { id: user.to_param }, session: valid_session
        }.to change(User, :count).by(-1)
      end

      it 'redirects to the users list' do
        delete :destroy, params: { id: user.to_param }, session: valid_session
        expect(response).to redirect_to(login_path)
      end

      it 'keep last admin user' do
        admin_user
        expect {
          delete :destroy, params: { id: admin_user.to_param }, session: valid_session
        }.to change(User, :count).by(0)
      end
    end
    context 'by not correct user' do
      it 'redirects to root path' do
        log_in other_user
        delete :destroy, params: { id: user.to_param }, session: valid_session
        expect(response).to redirect_to(:root)
      end
    end
  end
end

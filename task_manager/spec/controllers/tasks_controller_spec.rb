# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TasksController, type: :controller do
  before do
    user = create(:user)
    log_in user
  end
  # This should return the minimal set of attributes required to create a valid
  # Task. As you add validations to Task, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) {
    {
      name: 'name',
      status: 0,
      description: 'description',
      due_date: Date.current,
    }
  }

  let(:invalid_attributes) {
    {
      name: '',
    }
  }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # TasksController. Be sure to keep this updated too.
  let(:valid_session) {
    {
      name: 'user name',
      password: 'password',
      password_digest: User.digest('password'),
    }
  }

  describe 'GET #index' do
    it 'returns a success response' do
      current_user.tasks.create! valid_attributes
      get :index, params: {}, session: valid_session
      expect(response).to be_successful
    end
  end

  describe 'GET #show' do
    it 'returns a success response' do
      task = current_user.tasks.create! valid_attributes
      get :show, params: { user_id: task.user.id, id: task.to_param }, session: valid_session
      expect(response).to be_successful
    end
  end

  describe 'GET #new' do
    it 'returns a success response' do
      get :new, params: { user_id: current_user.id }, session: valid_session
      expect(response).to be_successful
    end
  end

  describe 'GET #edit' do
    it 'returns a success response' do
      task = current_user.tasks.create! valid_attributes
      get :edit, params: { user_id: task.user.id, id: task.to_param }, session: valid_session
      expect(response).to be_successful
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new Task' do
        expect {
          post :create, params: { user_id: current_user.id, task: valid_attributes }, session: valid_session
        }.to change(Task, :count).by(1)
      end

      it 'redirects to the created task' do
        post :create, params: { user_id: current_user.id, task: valid_attributes }, session: valid_session
        expect(response).to redirect_to([current_user, Task.last])
      end
    end

    context 'with invalid params' do
      it 'returns a success response (i.e. to display the "new" template)' do
        post :create, params: { user_id: current_user.id, task: invalid_attributes }, session: valid_session
        expect(response).to be_successful
      end
    end
  end

  describe 'PUT #update' do
    context 'with valid params' do
      let(:new_attributes) {
        { name: 'new name', status: 1, description: 'new description', due_date: Date.tomorrow }
      }

      it 'updates the requested task' do
        task = current_user.tasks.create! valid_attributes
        put :update, params: { user_id: task.user.id, id: task.to_param, task: new_attributes }, session: valid_session
        expect { task.reload }.to(
          change(task, :name).from('name').to('new name')
          .and(change(task, :status).from(0).to(1))
          .and(change(task, :description).from('description').to('new description'))
          .and(change(task, :due_date).from(Date.current).to(Date.tomorrow)),
        )
      end

      it 'redirects to the task' do
        task = current_user.tasks.create! valid_attributes
        put :update, params: { user_id: task.user.id, id: task.to_param, task: valid_attributes }, session: valid_session
        expect(response).to redirect_to([current_user, task])
      end
    end

    context 'with invalid params' do
      it 'returns a success response (i.e. to display the "edit" template)' do
        task = current_user.tasks.create! valid_attributes
        put :update, params: { user_id: task.user.id, id: task.to_param, task: invalid_attributes }, session: valid_session
        expect(response).to be_successful
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the requested task' do
      task = current_user.tasks.create! valid_attributes
      expect {
        delete :destroy, params: { user_id: task.user.id, id: task.to_param }, session: valid_session
      }.to change(Task, :count).by(-1)
    end

    it 'redirects to the tasks list' do
      task = current_user.tasks.create! valid_attributes
      delete :destroy, params: { user_id: task.user.id, id: task.to_param }, session: valid_session
      expect(response).to redirect_to(user_tasks_path(current_user))
    end
  end
end

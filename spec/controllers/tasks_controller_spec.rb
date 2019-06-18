# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TasksController, type: :controller do
  let(:user) { create(:user) }

  before do
    user_login(user: user)
  end

  describe 'GET #index' do
    it 'returns http success' do
      get :index, params: {}

      expect(response).to be_successful
      expect(response).to render_template('tasks/index')
    end
  end

  describe 'GET #new' do
    it 'returns http success' do
      get :new

      expect(response).to be_successful
      expect(response).to render_template('tasks/new')
    end
  end

  describe 'POST #create' do
    let(:params) do
      {
        task: {
          name: 'task name',
          status: :waiting,
          finished_on: Date.current,
        },
      }
    end

    it 'creates a new task and returns success' do
      post :create, params: params

      expect(response).to have_http_status(:redirect)
      expect(response).to redirect_to(task_path(assigns(:task).id))
    end

    context '終了期限に入力がないと' do
      before do
        params[:task][:finished_on] = nil
      end

      it "returns a success response (i.e. to display the 'new' template)" do
        post :create, params: params

        expect(response).to be_successful
        expect(response).to render_template('tasks/new')
        expect(assigns(:task).errors[:finished_on]).to be_present
      end
    end

    context '終了期限に過去日を入力すると' do
      before do
        params[:task][:finished_on] = 1.day.ago.to_date
      end

      it "returns a success response (i.e. to display the 'new' template)" do
        post :create, params: params

        expect(response).to be_successful
        expect(response).to render_template('tasks/new')
        expect(assigns(:task).errors[:finished_on]).to be_present
      end
    end
  end

  describe 'GET #show' do
    let(:task) { create(:task, user: user) }

    it 'returns a success response' do
      get :show, params: { id: task.to_param }

      expect(response).to be_successful
      expect(response).to render_template('tasks/show')
    end

    context '他のユーザーが作成したタスクを参照すると' do
      let(:other_user) {
        create(:user,
               name: 'other user',
               email: 'other@test.com',
               email_confirmation: 'other@test.com',
              )
      }
      let(:task) { create(:task, user: other_user) }

      it 'returns not found' do
        get :show, params: { id: task.to_param }

        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe 'GET #edit' do
    let(:task) { create(:task, user: user) }
    it 'returns a success response' do
      get :edit, params: { id: task.to_param }

      expect(response).to be_successful
      expect(response).to render_template('tasks/edit')
    end
  end

  describe 'PATCH #update' do
    let(:task) { create(:task, user: user) }
    let(:params) do
      {
        id: task.id,
        task: {
          name: 'update',
          status: :completed,
        },
      }
    end

    it 'updates a new task and returns success' do
      patch :update, params: params

      expect(response).to have_http_status(:redirect)
      expect(response).to redirect_to(task_path(assigns(:task).id))
      expect(task.reload.name).to eq('update')
    end
  end

  describe 'DELETE #destroy' do
    let(:task) { create(:task, status: :work_in_progress, user: user) }

    it 'destroys the requested task' do
      delete :destroy, params: { id: task.to_param }

      expect(response).to have_http_status(:redirect)
      expect(response).to redirect_to(root_path)
      expect(Task.count).to eq(0)
    end
  end
end

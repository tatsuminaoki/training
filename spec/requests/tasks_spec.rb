require 'rails_helper'

describe TasksController, type: :request do
  let!(:user) { create(:user) }
  let!(:task) { create(:task, user_id: user.id) }

  before do
    allow_any_instance_of(ApplicationController).to receive(:signed_in?).and_return(true)
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
  end

  describe 'GET #index' do
    it 'ステータスコードが200' do
      get tasks_url
      expect(response.status).to eq 200
    end
  end

  describe 'GET #show' do
    it 'ステータスコードが200' do
      get task_path(task)
      expect(response.status).to eq 200
    end
  end

  describe 'GET #new' do
    it 'ステータスコードが200' do
      get new_task_path
      expect(response.status).to eq 200
    end
  end

  describe 'GET #edit' do
    it 'ステータスコードが200' do
      get edit_task_path(task)
      expect(response.status).to eq 200
    end
  end

  describe 'POST #create' do
    subject { post tasks_url, params: { task: attributes_for(:task) } }
    it { is_expected.to eq 302 }
    it { expect{subject}.to change(Task, :count).by(1) }
    it { is_expected.to redirect_to(task_path(Task.last)) }
  end

  describe 'PATCH #update' do
    let(:task) { create(:task, title: 'old title', detail: 'old detail', user_id: user.id) }
    let(:update_attributes) { { title: 'new title', detail: 'new detail' } }
    subject { put task_url(task), params: { task: update_attributes } }

    it { is_expected.to eq 302 }
    it { expect{subject}.to change { Task.last.title }.from('old title').to('new title') }
    it { is_expected.to redirect_to(task_path(Task.last)) }
  end

  describe 'DELETE #destroy' do
    subject { delete task_url(task) }

    it { is_expected.to eq 302 }
    it { expect{subject}.to change(Task, :count).by(-1) }
    it { is_expected.to redirect_to(tasks_url) }
  end
end

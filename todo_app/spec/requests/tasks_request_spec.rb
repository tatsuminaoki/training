# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Tasks', type: :request do
  describe 'GET /tasks' do
    it 'return 200' do
      get tasks_path
      expect(response).to have_http_status(200)
    end

    context 'when tasks exists' do
      let!(:task) { create(:task, name: '@my_task@') }

      it 'display tasks' do
        get tasks_path
        expect(response.body).to include('@my_task@')
      end
    end

    context 'when tasks not exists' do
      it 'display blank message' do
        get tasks_path
        expect(response.body).to include('タスクは登録されていません')
      end
    end
  end

  describe 'GET /tasks/new' do
    it 'return 200' do
      get new_task_path
      expect(response).to have_http_status(200)
    end

    it 'render form' do
      get new_task_path
      expect(response.body).to match(/<input.*?task\[name\].*?>/)
      expect(response.body).to include('<input type="submit"')
    end
  end

  describe 'POST /tasks' do
    context 'when failed to save' do
      before do
        allow_any_instance_of(Task).to receive(:save).and_return(false)
      end

      it 'return 200' do
        post tasks_path, params: { task: attributes_for(:task) }
        expect(response).to have_http_status(200)
      end

      it 're render form' do
        post tasks_path, params: { task: attributes_for(:task) }
        expect(response.body).to match(/<input.*?task\[name\].*?>/)
        expect(response.body).to include('<input type="submit"')
      end
    end

    context 'when succeeded to save' do
      it 'persisted' do
        expect {
          post tasks_path, params: { task: attributes_for(:task) }
        }.to change(Task, :count).by(1)
      end

      it 'redirect to #show' do
        post tasks_path, params: { task: attributes_for(:task) }
        expect(response).to have_http_status(302)
        expect(response.header['Location']).to include(task_path(Task.last.id))
      end

      it 'set flash message' do
        post tasks_path, params: { task: attributes_for(:task) }
        expect(flash[:success]).to eq('タスクを作成しました。')
      end
    end
  end

  describe 'GET /tasks/:id' do
    let!(:task) { create(:task, name: '@my_task@') }

    context 'when specify correct id' do
      it 'return 200' do
        get task_path(id: task.id)
        expect(response).to have_http_status(200)
      end

      it 'display task properties' do
        get task_path(id: task.id)
        expect(response.body).to include('@my_task@')
      end
    end

    context 'when specify invalid id' do
      it 'raise ActiveRecord::RecordNotFound' do
        expect { get task_path(id: 0) }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end

  describe 'GET /tasks/:id/edit' do
    let!(:task) { create(:task, name: '@my_task@') }

    it 'return 200' do
      get edit_task_path(id: task.id)
      expect(response).to have_http_status(200)
    end

    it 'render form' do
      get edit_task_path(id: task.id)
      expect(response.body).to match(/<input.*?task\[name\].*?>/)
      expect(response.body).to include('<input type="submit"')
    end
  end

  describe 'PUT /tasks/:id' do
    let!(:task) { create(:task, name: '@my_task@') }

    context 'when failed to save' do
      before do
        allow_any_instance_of(Task).to receive(:update).and_return(false)
      end

      it 'return 200' do
        put task_path(id: task.id), params: { task: attributes_for(:task) }
        expect(response).to have_http_status(200)
      end

      it 're render form' do
        put task_path(id: task.id), params: { task: attributes_for(:task) }
        expect(response.body).to match(/<input.*?task\[name\].*?>/)
        expect(response.body).to include('<input type="submit"')
      end
    end

    context 'when succeeded to save' do
      it 'persisted' do
        expect {
          put task_path(id: task.id), params: { task: { name: '@updated_my_task@' } }
        }.to change { Task.last.name }.from('@my_task@').to('@updated_my_task@')
      end

      it 'redirect to #show' do
        put task_path(id: task.id), params: { task: attributes_for(:task) }
        expect(response).to have_http_status(302)
        expect(response.header['Location']).to include(task_path(Task.last.id))
      end

      it 'set flash message' do
        put task_path(id: task.id), params: { task: attributes_for(:task) }
        expect(flash[:success]).to eq('タスクを更新しました。')
      end
    end
  end

  describe 'DELETE /tasks/:id' do
    let!(:task) { create(:task) }

    context 'when failed to destroy' do
      before do
        allow_any_instance_of(Task).to receive(:destroy).and_return(false)
      end

      it 'redirect to #show' do
        delete task_path(id: task.id)
        expect(response).to have_http_status(302)
        expect(response.header['Location']).to include(task_path(Task.last.id))
      end

      it 'set flash message' do
        delete task_path(id: task.id)
        expect(flash[:error]).to include('タスクの削除に削除しました。')
      end
    end

    context 'when succeeded to destroy' do
      it 'redirect to #index' do
        delete task_path(id: task.id)
        expect(response).to have_http_status(302)
        expect(response.header['Location']).to include(tasks_path)
      end

      it 'set flash message' do
        delete task_path(id: task.id)
        expect(flash[:success]).to include('タスクを削除しました。')
      end
    end
  end
end

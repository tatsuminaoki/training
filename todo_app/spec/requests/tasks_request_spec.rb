# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Tasks', type: :request do
  describe 'GET /tasks' do
    it 'returns 200' do
      get tasks_path
      expect(response).to have_http_status(200)
    end

    context 'when tasks exists' do
      let!(:task) { create(:task, name: '@my_task@') }

      it 'displays tasks' do
        get tasks_path
        expect(response.body).to include('@my_task@')
      end
    end

    context 'when tasks not exists' do
      it 'displays blank message' do
        get tasks_path
        expect(response.body).to include('タスクは登録されていません')
      end
    end

    describe 'search' do
      before do
        create(:task, name: 'hogehoge', status: :initial)
        create(:task, name: 'fugafuga', status: :in_progress)
        create(:task, name: 'hogefuga', status: :done)
      end

      context 'when queries not exists' do
        it 'displays all tasks' do
          get tasks_path
          expect(response.body).to include('hogehoge')
          expect(response.body).to include('fugafuga')
          expect(response.body).to include('hogefuga')
        end
      end

      context 'when name query exists' do
        it 'searched by name' do
          get tasks_path(q: { name: 'hoge' })
          expect(response.body).to include('hogehoge')
          expect(response.body).not_to include('fugafuga')
          expect(response.body).to include('hogefuga')
        end
      end

      context 'when status query exists' do
        it 'searched by statuses' do
          get tasks_path(q: { statuses: [:done] })
          expect(response.body).not_to include('hogehoge')
          expect(response.body).not_to include('fugafuga')
          expect(response.body).to include('hogefuga')
        end
      end
    end
  end

  describe 'GET /tasks/new' do
    it 'returns 200' do
      get new_task_path
      expect(response).to have_http_status(200)
    end

    it 'renders form' do
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

      it 'returns 200' do
        post tasks_path, params: { task: attributes_for(:task) }
        expect(response).to have_http_status(200)
      end

      it 'rerenders form' do
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

      it 'redirects to #show' do
        post tasks_path, params: { task: attributes_for(:task) }
        expect(response).to have_http_status(302)
        expect(response.header['Location']).to include(task_path(Task.last.id))
      end

      it 'sets flash message' do
        post tasks_path, params: { task: attributes_for(:task) }
        expect(flash[:success]).to eq('タスクを作成しました。')
      end
    end
  end

  describe 'GET /tasks/:id' do
    let!(:task) { create(:task, name: '@my_task@') }

    context 'when specify correct id' do
      it 'returns 200' do
        get task_path(id: task.id)
        expect(response).to have_http_status(200)
      end

      it 'displays task properties' do
        get task_path(id: task.id)
        expect(response.body).to include('@my_task@')
      end
    end

    context 'when specify invalid id' do
      it 'raises ActiveRecord::RecordNotFound' do
        expect { get task_path(id: 0) }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end

  describe 'GET /tasks/:id/edit' do
    let!(:task) { create(:task, name: '@my_task@') }

    it 'returns 200' do
      get edit_task_path(id: task.id)
      expect(response).to have_http_status(200)
    end

    it 'renders form' do
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

      it 'returns 200' do
        put task_path(id: task.id), params: { task: attributes_for(:task) }
        expect(response).to have_http_status(200)
      end

      it 'rerenders form' do
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

      it 'redirects to #show' do
        put task_path(id: task.id), params: { task: attributes_for(:task) }
        expect(response).to have_http_status(302)
        expect(response.header['Location']).to include(task_path(Task.last.id))
      end

      it 'sets flash message' do
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

      it 'redirects to #show' do
        delete task_path(id: task.id)
        expect(response).to have_http_status(302)
        expect(response.header['Location']).to include(task_path(Task.last.id))
      end

      it 'sets flash message' do
        delete task_path(id: task.id)
        expect(flash[:error]).to include('タスクの削除に削除しました。')
      end
    end

    context 'when succeeded to destroy' do
      it 'redirects to #index' do
        delete task_path(id: task.id)
        expect(response).to have_http_status(302)
        expect(response.header['Location']).to include(tasks_path)
      end

      it 'sets flash message' do
        delete task_path(id: task.id)
        expect(flash[:success]).to include('タスクを削除しました。')
      end
    end
  end
end

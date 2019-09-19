# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Tasks', type: :request do
  shared_context 'logged in' do
    let!(:current_user) {
      user = create(:user)
      post session_path, params: { session: { email: 'hoge@hoge.com', password: 'password' } }
      user
    }
  end

  describe 'GET /tasks' do
    context 'when not logged in' do
      it 'redirects to /session/new' do
        get tasks_path
        expect(response).to have_http_status(302)
        expect(response.header['Location']).to include(new_session_path)
      end
    end

    context 'when logged in' do
      include_context 'logged in'

      it 'returns 200' do
        get tasks_path
        expect(response).to have_http_status(200)
      end

      context 'when tasks exists' do
        before do
          create(:task, name: '@my_task@', user: current_user)
          create(:task, name: '@others_task@')
        end

        it 'displays tasks (only mine)' do
          get tasks_path
          expect(response.body).not_to include('@others_task@')
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
          create(:task, name: 'hogehoge', status: :initial, user: current_user)
          create(:task, name: 'fugafuga', status: :in_progress, user: current_user)
          create(:task, name: 'hogefuga', status: :done, user: current_user)
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
  end

  describe 'GET /tasks/new' do
    context 'when not logged in' do
      it 'redirects to /session/new' do
        get new_task_path
        expect(response).to have_http_status(302)
        expect(response.header['Location']).to include(new_session_path)
      end
    end

    context 'when logged in' do
      include_context 'logged in'

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
  end

  describe 'POST /tasks' do
    context 'when not logged in' do
      it 'redirects to /session/new' do
        post tasks_path, params: { task: attributes_for(:task) }
        expect(response).to have_http_status(302)
        expect(response.header['Location']).to include(new_session_path)
      end
    end

    context 'when logged in' do
      include_context 'logged in'

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
        it 'persisted as my task' do
          expect {
            post tasks_path, params: { task: attributes_for(:task) }
          }.to change(Task, :count).by(1)
          expect(Task.last.user_id).to eq(current_user.id)
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
  end

  describe 'GET /tasks/:id' do
    context 'when not logged in' do
      it 'redirects to /session/new' do
        get task_path(id: create(:task).id)
        expect(response).to have_http_status(302)
        expect(response.header['Location']).to include(new_session_path)
      end
    end

    context 'when logged in' do
      include_context 'logged in'

      let(:task) { create(:task, name: '@my_task@', user: current_user) }

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
          expect {
            get task_path(id: 0)
          }.to raise_error(ActiveRecord::RecordNotFound)
        end
      end

      context 'when specify others task id' do
        it 'raises ActiveRecord::RecordNotFound' do
          expect {
            get task_path(id: create(:task).id)
          }.to raise_error(ActiveRecord::RecordNotFound)
        end
      end
    end
  end

  describe 'GET /tasks/:id/edit' do
    context 'when not logged in' do
      it 'redirects to /session/new' do
        get edit_task_path(id: create(:task).id)
        expect(response).to have_http_status(302)
        expect(response.header['Location']).to include(new_session_path)
      end
    end

    context 'when logged in' do
      include_context 'logged in'

      let(:task) { create(:task, name: '@my_task@', user: current_user) }

      it 'returns 200' do
        get edit_task_path(id: task.id)
        expect(response).to have_http_status(200)
      end

      it 'renders form' do
        get edit_task_path(id: task.id)
        expect(response.body).to match(/<input.*?task\[name\].*?>/)
        expect(response.body).to include('<input type="submit"')
      end

      context 'when specify others task id' do
        it 'raises ActiveRecord::RecordNotFound' do
          expect {
            get edit_task_path(id: create(:task).id)
          }.to raise_error(ActiveRecord::RecordNotFound)
        end
      end
    end
  end

  describe 'PUT /tasks/:id' do
    context 'when not logged in' do
      it 'redirects to /session/new' do
        put task_path(id: create(:task).id), params: { task: attributes_for(:task) }
        expect(response).to have_http_status(302)
        expect(response.header['Location']).to include(new_session_path)
      end
    end

    context 'when logged in' do
      include_context 'logged in'

      let!(:task) { create(:task, name: '@my_task@', user: current_user) }

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

      context 'when specify others task id' do
        it 'raises ActiveRecord::RecordNotFound' do
          expect {
            put task_path(id: create(:task).id), params: { task: attributes_for(:task) }
          }.to raise_error(ActiveRecord::RecordNotFound)
        end
      end
    end
  end

  describe 'DELETE /tasks/:id' do
    context 'when not logged in' do
      it 'redirects to /session/new' do
        delete task_path(id: create(:task).id)
        expect(response).to have_http_status(302)
        expect(response.header['Location']).to include(new_session_path)
      end
    end

    context 'when logged in' do
      include_context 'logged in'

      let!(:task) { create(:task, user: current_user) }

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

      context 'when specify others task id' do
        it 'raises ActiveRecord::RecordNotFound' do
          expect {
            delete task_path(id: create(:task).id)
          }.to raise_error(ActiveRecord::RecordNotFound)
        end
      end
    end
  end
end

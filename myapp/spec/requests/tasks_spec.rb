require 'rails_helper'

RSpec.describe 'Tasks', type: :request do
  describe 'POST /tasks/:id' do
    context 'Task creating is success' do
      it 'is created task' do
        project = create(:project, :with_group)
        post tasks_path, params: { task: {name: 'test1', description: 'test1', priority: 'high', group_id: project.groups.first.id, project_id: project.id} }
        expect(Task.count).to eq 1
        expect(flash[:alert]).to eq 'Success to create task'
      end
    end

    context 'Task creating is failed because, did not put task name' do
      it 'is not create task' do
        project = create(:project, :with_group)
        post tasks_path, params: { task: {name: nil, description: 'test1', priority: 'high', group_id: project.groups.first.id, project_id: project.id} }
        expect(Task.count).to eq 0
        expect(flash[:alert]).to eq 'Failed to create task'
      end
    end
  end

  describe 'PATCH /task/:id' do
    context 'Update success' do
      it 'is changing task name to test1' do
        project = create(:project, :with_group)
        task = create(:task, group: project.groups.first)

        patch task_path(task.id), params: { task: {name: 'test1', description: 'test1', priority: 'high'} }
        task.reload
        expect(task.name).to eq 'test1'
        expect(flash[:alert]).to eq 'Success to update task'
      end
    end

    context 'Task creating is failed because, did not put task name' do
      it 'is not change task name' do
        project = create(:project, :with_group)
        task = create(:task, group: project.groups.first)

        patch task_path(task.id), params: { task: {name: nil, description: 'test1', priority: 'high'} }
        task.reload
        expect(task.name).to eq 'test task name'
        expect(flash[:alert]).to eq 'Failed to update task'
      end
    end
  end

  describe 'DELETE /task/:id' do
    context 'Project deleting is success' do
      it 'is deleting taks' do
        project = create(:project, :with_group)
        task = create(:task, group: project.groups.first)

        delete task_path(task.id)
        expect(project.groups.first.tasks.count).to eq 0
        expect(flash[:alert]).to eq 'Deleted test task name task'
      end
    end

    context 'Task deleting is failed, because task id is not correct' do
      it 'is not delete task' do
        project = create(:project, :with_group)
        task = create(:task, group: project.groups.first)

        delete task_path(100)
        expect(project.groups.first.tasks.count).to eq 1
        expect(response).to have_http_status(500)
      end
    end
  end
end

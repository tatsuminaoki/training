require 'rails_helper'

RSpec.describe "Tasks", type: :request do
  describe "POST /tasks/:id" do
    context '登録成功' do
      example "Taskが作成される" do
        project = create(:project, :with_group)
        post tasks_path, params: { task: {name: 'test1', description: 'test1', priority: 'high', group_id: project.groups.first.id, project_id: project.id} }
        expect(Task.count).to eq 1
        expect(flash[:alert]).to eq 'Success to create task'
      end
    end

    context 'パラメーターの情報が正しく設定されてなくて登録失敗' do
      example "Taskが作成されない" do
        project = create(:project, :with_group)
        post tasks_path, params: { task: {name: nil, description: 'test1', priority: 'high', group_id: project.groups.first.id, project_id: project.id} }
        expect(Task.count).to eq 0
        expect(flash[:alert]).to eq 'Failed to create task'
      end
    end
  end

  describe "PATCH /task/:id" do
    context '変更成功' do
      example "taskの名前が変更される" do
        project = create(:project, :with_group)
        task = create(:task, group: project.groups.first)

        patch task_path(task.id), params: { task: {name: 'test1', description: 'test1', priority: 'high'} }
        task.reload
        expect(task.name).to eq 'test1'
        expect(flash[:alert]).to eq 'Success to update task'
      end
    end

    context '変更失敗' do
      example "taskの名前が変更されない" do
        project = create(:project, :with_group)
        task = create(:task, group: project.groups.first)

        patch task_path(task.id), params: { task: {name: nil, description: 'test1', priority: 'high'} }
        task.reload
        expect(task.name).to eq 'test'
        expect(flash[:alert]).to eq 'Failed to update task'
      end
    end
  end

  describe "DELETE /task/:id" do
    context '削除成功' do
      example "Taskが削除される" do
        project = create(:project, :with_group)
        task = create(:task, group: project.groups.first)

        delete task_path(task.id)
        expect(project.groups.first.tasks.count).to eq 0
        expect(flash[:alert]).to eq 'Deleted test task'
      end
    end

    context '削除失敗' do
      example "ProjectとGroupsは削除されない" do
        project = create(:project, :with_group)
        task = create(:task, group: project.groups.first)

        delete task_path(100)
        expect(project.groups.first.tasks.count).to eq 1
        expect(response).to have_http_status(500)
      end
    end
  end
end

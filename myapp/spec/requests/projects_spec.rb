require 'rails_helper'

RSpec.describe 'Projects', type: :request do
  describe 'POST /projects/:id' do
    context 'Project creating is success' do
      it 'is creating 1 project and 4 Groups' do
        post projects_path, params: { project: {name: 'TEST1'} }
        expect(Project.count).to eq 1
        expect(Group.count).to eq 4
        expect(flash[:alert]).to eq 'Success to create project'
      end
    end

    context 'Project creating is failed because, did not put project name' do
      it 'is not create project and groups' do
        post projects_path, params: { project: {name: nil} }
        expect(Project.count).to eq 0
        expect(Group.count).to eq 0
        expect(flash[:alert]).to eq 'Failed to create project'
      end
    end
  end

  describe 'PATCH /projects/:id' do
    context 'Update success' do
      it 'is changing project name to test1' do
        project = create(:project)

        patch project_path(project.id), params: { project: {name: 'test1'} }
        project.reload
        expect(project.name).to eq 'test1'
      end
    end

    context 'Project updating is failed because, did not put project name' do
      it 'is not change project name' do
        project = create(:project)
        original_project_name = project.name

        patch project_path(project.id), params: { project: {name: nil} }
        project.reload
        expect(project.name).to eq original_project_name
      end
    end
  end

  describe 'DELETE /projects/:id' do
    context 'Project deleting is success' do
      it 'is deleting project and reference groups' do
        Project.new(name: 'test').create!
        project = Project.first

        delete project_path(project.id)
        expect(Project.count).to eq 0
        expect(Group.count).to eq 0
        expect(flash[:alert]).to eq 'Closed test project'
      end
    end

    context 'Project deleting is failed, because project id is not correct' do
      it 'is not delete project and reference groups' do
        Project.new(name: 'test').create!

        delete project_path(10000)
        expect(Project.count).to eq 1
        expect(Group.count).to eq 4
        expect(response).to have_http_status(500)
      end
    end
  end
end

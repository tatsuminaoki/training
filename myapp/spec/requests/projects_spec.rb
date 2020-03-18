require 'rails_helper'

RSpec.describe 'Projects', type: :request do
  describe 'POST /projects/:id' do
    context 'Project creating is success' do
      let!(:current_user) { create(:user) }
      it 'is creating 1 project and 4 Groups' do
        post projects_path, params: { project: {name: 'TEST1'} }
        expect(Project.count).to eq 1
        expect(Group.count).to eq 4
        expect(flash[:alert]).to eq 'Success to create project'
        expect(response.status).to eq 302
      end
    end

    context 'Project creating is failed because, did not put project name' do
      it 'is not create project and groups' do
        post projects_path, params: { project: {name: nil} }
        expect(Project.count).to eq 0
        expect(Group.count).to eq 0
        expect(flash[:alert]).to eq 'Failed to create project'
        expect(response.status).to eq 302
      end
    end
  end

  describe 'PATCH /projects/:id' do
    let!(:current_user) { create(:user) }
    let(:project) { create(:project) }
    let!(:user_project) { create(:user_project, user: current_user, project: project) }
    context 'Update success' do
      it 'is changing project name to test1' do
        patch project_path(locale: 'en', id: project.id), params: { project: {name: 'test1'} }
        project.reload
        expect(project.name).to eq 'test1'
        expect(response).to be_successful
      end
    end

    context 'Project updating is failed because, did not put project name' do
      it 'is not change project name' do
        original_project_name = project.name

        patch project_path(locale: 'en', id: project.id), params: { project: {name: nil} }
        project.reload
        expect(project.name).to eq original_project_name
      end
    end
  end

  describe 'DELETE /projects/:id' do
    let!(:current_user) { create(:user) }
    let(:project) { create(:project) }
    let!(:user_project) { create(:user_project, user: current_user, project: project) }
    context 'Project deleting is success' do
      it 'is deleting project and reference groups' do
        delete project_path(locale: 'en', id: project.id)
        expect(Project.count).to eq 0
        expect(Group.count).to eq 0
        expect(flash[:alert]).to eq 'Success to destroy project'
        expect(response.status).to eq 302
      end
    end
  end
end

require 'rails_helper'

RSpec.describe "Projects", type: :request do
  describe "POST /projects/:id" do
    context '登録成功' do
      example "Projectが作成されて、デフォルトのGroupsが４つ作成される" do
        post projects_path, params: { project: {name: 'TEST1'} }
        expect(Project.count).to eq 1
        expect(Group.count).to eq 4
        expect(flash[:alert]).to eq 'Success to create project'
      end
    end

    context '名前が設定されてなくて登録失敗' do
      example "ProjectとGroupsが作られない" do
        post projects_path, params: { project: {name: nil} }
        expect(Project.count).to eq 0
        expect(Group.count).to eq 0
        expect(flash[:alert]).to eq 'Failed to create project'
      end
    end
  end

  describe "PATCH /projects/:id" do
    context '変更成功' do
      example "Projectの名前が変更される" do
        project = create(:project)

        patch project_path(locale: 'en', id: project.id), params: { project: {name: 'test1'} }
        project.reload
        expect(project.name).to eq 'test1'
      end
    end

    context '変更失敗' do
      example "Projectが作成されて、デフォルトのGroupsが４つ作成される" do
        project = create(:project)
        original_project_name = project.name

        patch project_path(locale: 'en', id: project.id), params: { project: {name: nil} }
        project.reload
        expect(project.name).to eq original_project_name
      end
    end
  end

  describe "DELETE /projects/:id" do
    context '削除成功' do
      example "Projectが削除され、そして紐ついてるGroupsも全部削除される" do
        Project.new(name: 'test').create!
        project = Project.first

        delete project_path(locale: 'en', id: project.id)
        expect(Project.count).to eq 0
        expect(Group.count).to eq 0
        expect(flash[:alert]).to eq 'Destroy to create project'
      end
    end

    context '削除失敗' do
      example "ProjectとGroupsは削除されない" do
        Project.new(name: 'test').create!

        delete project_path(locale: 'en', id: 10000)
        expect(Project.count).to eq 1
        expect(Group.count).to eq 4
        expect(response).to have_http_status(404)
      end
    end
  end
end

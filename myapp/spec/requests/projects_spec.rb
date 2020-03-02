require 'rails_helper'

RSpec.describe "Projects", type: :request do
  describe "POST /projects/:id" do
    context '登録成功' do
      example "Projectが作成されて、デフォルトのGroupsが４つ作成される" do
        post project_path
        expect(response).to have_http_status(200)
      end
    end

    context '登録失敗' do
      example "Projectが作成されて、デフォルトのGroupsが４つ作成される" do
        post project_path
        expect(response).to have_http_status(200)
      end
    end
  end

  describe "PATCH /projects/:id" do
    context '変更成功' do
      example "Projectの名前が変更される" do
        patch project_path()
        expect(response).to have_http_status(200)
      end
    end
  end

  describe "DELETE /projects/:id" do
    context '削除成功' do
      example "Projectが削除され、そして紐ついてるGroupsも全部削除される" do
        delete project_path()
        expect(response).to have_http_status(200)
      end
    end
  end
end
